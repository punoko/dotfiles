#!/usr/bin/env python3
import logging
import os
from datetime import datetime


class Symlink:
    def __init__(self) -> None:
        date = datetime.now().isoformat(timespec="seconds")
        self.backup_dir = os.path.join(DOTFILES, "backup", date)

    def make(self, src: str, dst: str) -> None:
        if os.path.lexists(dst):
            if os.path.realpath(dst) == src:
                logger.info(f"OK {dst}")
                return
            os.makedirs(self.backup_dir, exist_ok=True)
            backup = os.path.join(self.backup_dir, os.path.basename(dst))
            os.rename(dst, backup)
            logger.info(f"created {os.path.relpath(backup)}")
        os.makedirs(os.path.dirname(dst), exist_ok=True)
        os.symlink(src, dst)
        logger.info(f"symlinked {dst} -> {src}")


def main():
    symlink = Symlink()

    for item in ["zshrc", "gnupg/gpg.conf", "gnupg/gpg-agent.conf"]:
        src = os.path.join(DOTFILES, item)
        dst = os.path.join(HOME, f".{item}")
        symlink.make(src, dst)

    for item in ["mpv", "wezterm", "zed"]:
        src = os.path.join(DOTFILES, item)
        dst = os.path.join(HOME, ".config", item)
        symlink.make(src, dst)

    is_darwin = os.uname().sysname == "Darwin"
    for item in ["streamlink"]:
        config_dir = "Library/Application Support" if is_darwin else ".config"
        src = os.path.join(DOTFILES, item)
        dst = os.path.join(HOME, config_dir, item)
        symlink.make(src, dst)


if __name__ == "__main__":
    logging.basicConfig(level=logging.INFO, format="%(levelname)s: %(message)s")
    logger = logging.getLogger(__name__)
    DOTFILES = os.path.dirname(os.path.abspath(__file__))
    HOME = os.environ["HOME"]
    main()
