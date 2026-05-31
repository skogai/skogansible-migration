from pathlib import Path
import unittest

import yaml


ROOT = Path(__file__).resolve().parents[1]


def load_yaml(path):
    with path.open() as handle:
        return yaml.safe_load(handle) or []


class AnsiblePolicyTest(unittest.TestCase):
    def test_aur_module_tasks_run_as_aur_builder(self):
        task_files = sorted((ROOT / "roles" / "packages" / "tasks").glob("*.yml"))

        offenders = []
        for path in task_files:
            for task in load_yaml(path):
                if "kewlfft.aur.aur" not in task:
                    continue

                if task.get("become") is not True or task.get("become_user") != "aur_builder":
                    offenders.append(f"{path.relative_to(ROOT)}: {task.get('name')}")

        self.assertEqual([], offenders)

    def test_playbooks_do_not_use_play_level_become(self):
        offenders = []
        for path in sorted((ROOT / "playbooks").glob("*.yml")):
            for play in load_yaml(path):
                if play.get("become") is True:
                    offenders.append(f"{path.relative_to(ROOT)}: {play.get('name')}")

        self.assertEqual([], offenders)

    def test_vault_files_are_encrypted(self):
        vault_files = sorted((ROOT / "vars").glob("*vault*.yml"))

        self.assertTrue(vault_files, "expected at least one vault file")
        for path in vault_files:
            first_line = path.read_text().splitlines()[0]
            self.assertTrue(
                first_line.startswith("$ANSIBLE_VAULT;1.1;AES256"),
                f"{path.relative_to(ROOT)} is not encrypted with AES256",
            )
