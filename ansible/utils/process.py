from __future__ import annotations

import subprocess
import sys

from typing import Any, List, Optional, Union
from utils import echo


def run_checked(
    subprocess_cmd: List[str],
    *,
    static_echo_status: Optional[str] = None,
    user_suggestion: Optional[str] = None,
    **kwargs: Any,
) -> subprocess.CompletedProcess[Union[str, bytes]]:
    if static_echo_status is None:
        echo.status(f"$ {' '.join(subprocess_cmd)}")
    else:
        echo.status(static_echo_status)

    completed_process = subprocess.run(subprocess_cmd, **kwargs)
    check_returncode(completed_process, user_suggestion)
    return completed_process


def check_returncode(
    process: subprocess.CompletedProcess[Union[str, bytes]], user_suggestion: Optional[str] = None
) -> None:
    if process.returncode == 0:
        return

    echo.error(f"Command failed: {' '.join(process.args)}")
    if process.stdout is not None:
        echo.status("Captured stdout:")
        echo.status(process.stdout)

    if process.stderr is not None:
        echo.status("Captured stderr:")
        echo.status(process.stderr)

    if user_suggestion is not None:
        echo.status(user_suggestion)

    sys.exit(process.returncode)
