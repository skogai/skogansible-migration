from pathlib import Path
import unittest

import yaml


ROOT = Path(__file__).resolve().parents[1]


class CiContractTest(unittest.TestCase):
    def test_ci_runs_shared_test_script_on_push_and_pull_request(self):
        workflow = ROOT / ".github" / "workflows" / "test.yml"

        self.assertTrue(workflow.exists(), "missing .github/workflows/test.yml")

        data = yaml.safe_load(workflow.read_text())
        triggers = data.get(True) or data.get("on") or {}
        jobs = data.get("jobs", {})
        steps = [
            step
            for job in jobs.values()
            for step in job.get("steps", [])
            if isinstance(step, dict)
        ]

        self.assertIn("push", triggers)
        self.assertIn("pull_request", triggers)
        self.assertTrue(
            any("./scripts/test.sh" in step.get("run", "") for step in steps),
            "CI must delegate to ./scripts/test.sh",
        )


if __name__ == "__main__":
    unittest.main()
