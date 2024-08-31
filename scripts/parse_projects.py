from multiprocessing import Process
from dbt.cli.main import dbtRunner, dbtRunnerResult
from pathlib import Path

dbt_projects_path = Path("../dbt")


def dbt_deps(project_path: Path) -> dbtRunnerResult:
    print(f"Running dbt deps for {project_path}")
    dbt_runner = dbtRunner()
    return dbt_runner.invoke(["deps", "--project-dir", str(project_path.absolute())])

def dbt_parse(project_path: Path) -> dbtRunnerResult:
    print(f"Running dbt parse for {project_path}")
    dbt_runner = dbtRunner()
    return dbt_runner.invoke(["parse", "--project-dir", str(project_path.absolute())])

def compile_dbt_manifest(project_path: Path):
    print(f"====== Compiling dbt manifest for {project_path} ======")
    
    run_func_as_process(dbt_deps, (project_path,))
    run_func_as_process(dbt_parse, (project_path,))
    print(f"====== Finished compiling dbt manifest for {project_path} ======")

def compile_dbt_manifests(dbt_projects_path: Path):
    for project_path in dbt_projects_path.iterdir():
        if project_path.is_dir():
            if "dbt_project.yml" not in (p.name for p in project_path.iterdir()):
                print(f"Skipping {project_path} due to missing dbt_project.yml")
                continue
            
            run_func_as_process(compile_dbt_manifest, (project_path,))

def run_func_as_process(func, args):
    p = Process(target=func, args=args)
    p.start()
    p.join()

if __name__ == "__main__":
    compile_dbt_manifests(dbt_projects_path)