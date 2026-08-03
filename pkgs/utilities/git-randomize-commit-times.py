#!/usr/bin/env python3
"""
Git Commit Time Randomizer

Automatically adjusts commit timestamps for unpushed commits with randomized
intervals (5-20 minutes base) adjusted by commit size.
"""

import subprocess
import random
import os
import tempfile
import argparse
from datetime import datetime, timedelta
from dataclasses import dataclass
from typing import cast


@dataclass
class CommitInfo:
    hash: str
    message: str
    insertions: int
    deletions: int
    files_changed: int

    @property
    def total_changes(self) -> int:
        return self.insertions + self.deletions


def run_git_command(cmd: list[str]) -> str:
    """Run a git command and return its output."""
    try:
        result = subprocess.run(
            ["git"] + cmd, capture_output=True, text=True, check=True
        )
        return result.stdout.strip()
    except subprocess.CalledProcessError as e:
        raise RuntimeError(f"Git command failed: {cast(str, e.stderr).strip()}")


def get_commits_to_process(num_commits: int | None = None) -> list[str]:
    """
    Get list of commit hashes to process.
    If num_commits is specified, gets the last N commits from HEAD.
    Otherwise, gets unpushed commits in chronological order (oldest first).
    """
    if num_commits is not None:
        if num_commits <= 0:
            return []
        # rev-list returns newest first, so we reverse it for chronological order
        output = run_git_command(["rev-list", "-n", str(num_commits), "HEAD"])
        if not output:
            return []
        return list(reversed(output.split("\n")))

    # Original logic for unpushed commits
    try:
        # Get commits that are ahead of origin
        output = run_git_command(["rev-list", "@{u}..HEAD"])
        if not output:
            return []
        return list(reversed(output.split("\n")))

    except RuntimeError as e:
        if "no upstream" in str(e).lower():
            print("No upstream branch found, processing all commits on current branch")
            output = run_git_command(["rev-list", "HEAD"])
            return list(reversed(output.split("\n")))
        raise


def get_commit_stats(commit_hash: str) -> CommitInfo:
    """Get detailed statistics for a commit."""
    # Get commit message
    message = run_git_command(["log", "-1", "--format=%s", commit_hash])

    # Use numstat to get accurate insertions/deletions
    stats_output = run_git_command(["show", "--numstat", "--format=", commit_hash])

    insertions = deletions = files_changed = 0

    for line in stats_output.split("\n"):
        parts = line.split("\t")
        if len(parts) == 3:
            ins, dels, _ = parts
            # Skip renames/copies (they show "-" instead of a number)
            if ins.isdigit():
                insertions += int(ins)
            if dels.isdigit():
                deletions += int(dels)
            files_changed += 1

    return CommitInfo(commit_hash, message, insertions, deletions, files_changed)


def calculate_time_interval(commit_info: CommitInfo) -> float:
    """Calculate time interval in minutes based on commit size, capped at 20."""
    total_changes = commit_info.total_changes

    base_interval = 2 + (total_changes / 200) * (20 - 2)

    # Cap at 20 minutes
    base_interval = min(20, base_interval)

    # Add ±15% jitter
    variation = random.uniform(0.75, 1.25)
    return base_interval * variation


def randomize_commit_times(num_commits: int | None) -> None:
    """Main function to randomize commit times."""
    if num_commits is not None:
        if num_commits > 0:
            commits_to_modify = get_commits_to_process(num_commits)
            print(f"📋 Processing {len(commits_to_modify)} commits")
        else:
            print(f"❌ Invalid number of commits to process: {num_commits}")
            return
    else:
        try:
            print("🔍 Finding unpushed commits...")
            commits_to_modify = get_commits_to_process()
            print(f"📋 Processing {len(commits_to_modify)} unpushed commits")
        except RuntimeError as e:
            print(f"❌ Error: {e}")
            return

    if not commits_to_modify:
        print("✅ No unpushed commits found.")
        return

    # Get current branch
    current_branch = run_git_command(["branch", "--show-current"])

    # Collect commit info
    commits_info: list[CommitInfo] = []
    for commit_hash in commits_to_modify:
        commit_info = get_commit_stats(commit_hash)
        commits_info.append(commit_info)
        print(
            f"  • {commit_info.hash[:8]}: {commit_info.message} ({commit_info.total_changes} changes)"
        )

    print("\n⏰ Calculating new timestamps...")

    # Start from current time and work backwards
    current_time = datetime.now()
    new_timestamps: list[tuple[CommitInfo, datetime]] = []

    # Work backwards from newest to oldest
    working_time = current_time
    for i in range(len(commits_info) - 1, -1, -1):
        commit_info = commits_info[i]
        interval_minutes = calculate_time_interval(commit_info)

        if i == len(commits_info) - 1:
            # Most recent commit gets current time minus small random offset
            working_time = current_time - timedelta(minutes=random.randint(1, 5))
        else:
            # Previous commits go further back
            working_time = working_time - timedelta(minutes=interval_minutes)

        new_timestamps.append((commit_info, working_time))
        print(
            f"  • {commit_info.hash[:8]}: {working_time.strftime('%Y-%m-%d %H:%M:%S')} "
            + f"({interval_minutes:.2f}min interval, {commit_info.total_changes} changes)"
        )

    # Reverse to get chronological order
    new_timestamps.reverse()

    print(f"\n❓ Do you want to proceed with these timestamp changes?")
    response = input("Enter 'y' to continue or 'n' to abort: ").strip().lower()

    if response != "y":
        print("🚫 Aborted by user.")
        return

    print(f"\n🔄 Starting automated rebase to update timestamps...")

    try:
        # Start interactive rebase using filter-branch approach instead
        print("🚀 Using git filter-branch for reliable timestamp updates...")

        # Build the filter script
        filter_script_lines = ["#!/bin/bash"]

        for commit_info, timestamp in new_timestamps:
            timestamp_str = timestamp.strftime("%Y-%m-%d %H:%M:%S")
            filter_script_lines.extend(
                [
                    f'if [ "$GIT_COMMIT" = "{commit_info.hash}" ]; then',
                    f'    export GIT_AUTHOR_DATE="{timestamp_str}"',
                    f'    export GIT_COMMITTER_DATE="{timestamp_str}"',
                    f"fi",
                ]
            )

        with tempfile.NamedTemporaryFile(
            mode="w", delete=False, suffix=".sh"
        ) as filter_file:
            _ = filter_file.write("\n".join(filter_script_lines))
            filter_script_path = filter_file.name

        _ = os.chmod(filter_script_path, 0o755)

        # Get the range for filter-branch
        oldest_commit = commits_to_modify[0]
        parent_commit = run_git_command(["rev-parse", f"{oldest_commit}^"])
        commit_range = f"{parent_commit}..HEAD"

        print(f"📝 Applying timestamps to commits in range: {commit_range}")

        # Run filter-branch
        filter_result = subprocess.run(
            [
                "git",
                "filter-branch",
                "--force",
                "--env-filter",
                f"source {filter_script_path}",
                commit_range,
            ],
            capture_output=True,
            text=True,
            env=os.environ,
        )

        # Clean up
        try:
            _ = os.unlink(filter_script_path)
        except:
            pass

        if filter_result.returncode == 0:
            print("✅ Timestamps updated successfully!")

            # Clean up filter-branch backup
            try:
                _ = subprocess.run(
                    [
                        "git",
                        "update-ref",
                        "-d",
                        "refs/original/refs/heads/" + current_branch,
                    ],
                    capture_output=True,
                )
            except:
                pass

        else:
            print(f"❌ Filter-branch failed: {filter_result.stderr}")
            return

    except Exception as e:
        print(f"❌ Error during timestamp update: {e}")
        return

    print("\n✅ Process completed!")
    print(
        f'💡 Verify the timestamps with: git log --format="%ai %s" -{len(commits_to_modify)}'
    )


if __name__ == "__main__":
    print("🎲 Git Commit Time Randomizer")
    print("=" * 40)

    # Verify we're in a git repository
    try:
        _ = run_git_command(["status"])
    except RuntimeError:
        print("❌ Not in a git repository!")
        exit(1)

    parser = argparse.ArgumentParser(
        description="Automatically adjusts commit timestamps for unpushed commits or a specified number of recent commits."
    )
    a = parser.add_argument(
        "-n",
        "--num-commits",
        type=int,
        default=None,
        help="Number of recent commits to modify (starting from HEAD). If not specified, modifies all unpushed commits.",
    )
    args = parser.parse_args()

    randomize_commit_times(cast(int, args.num_commits))
