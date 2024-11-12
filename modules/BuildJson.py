import subprocess
from homepagebuilder.interfaces.Events import on

@on('page.generate.return')
def your_func_name(page, env, result):
    try:
        subprocess.run(['python', r'H:\Project\modules\VersionJson.py'], check=True)
        print("VersionJson已构建")
    except subprocess.CalledProcessError as e:
        print(f"构建 VersionJson 时发生错误: {e}")
