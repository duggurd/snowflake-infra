from airflow.decorators import dag, task
from datetime import datetime
from dbt.cli.main import dbtRunner, dbtRunnerResult


def dbt_run_single_model_task(model_name: str, manifest: dbtRunnerResult):
    @task(task_id=f"dbt_run_single_model_{model_name}", start_date=datetime(2024, 1, 1), max_active_runs=1)
    def dbt_run_task():
        runner = dbtRunner(manifest)
        runner.invoke(["run", "-s", model_name])

    dbt_run_task


def task_from_dbt_node(node_unique_id: str, nodes: dict, node_tasks: dict):
    @task(
        task_id=node_unique_id,
        start_date=datetime(2024, 1, 1),
        max_active_runs=1,
    )
    def task_from_dbt_node():
        for ref in nodes[node_unique_id]["depends_on"]["nodes"]:
            if ref.beginswith("model."):
                if ref not in node_tasks:
                    node_tasks[ref] = dbt_run_single_model_task(ref.split(".")[-1], manifest)
                if node_unique_id not in node_tasks:
                    node_tasks[node_unique_id] = dbt_run_single_model_task(ref.split(".")[-1], manifest)
                
                node_tasks[ref] >> node_tasks[node_unique_id]
    return task_from_dbt_node

def dag_from_dbt_manifest(manifest: dict):
    @dag(
        dag_id=manifest["metadata"]["project_name"],
        start_date=datetime(2024, 1, 1),
        schedule_interval="0 0 * * *",
        catchup=False,
        max_active_runs=1,
    )
    def dag_from_dbt_manifest():
        # one task per node
        nodes = {
            nodes["unique_id"]: node
            for node in manifest["nodes"]
        }

        for node_unique_id, node in nodes.items():
            task_from_dbt_node(node_unique_id, nodes)

    return dag_from_dbt_manifest


dag_from_dbt_manifest()()