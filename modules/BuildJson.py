import subprocess
from homepagebuilder.interfaces.Events import on

@on('page.generate.return')
def your_func_name(page, env, result):
    try:
        # 修改为在 B 库文件夹的 Modules 文件夹下运行 VersionJson.py
        subprocess.run(['python', r'file-repo/Modules/VersionJson.py'], check=True)
        print("VersionJson已构建")
    except subprocess.CalledProcessError as e:
        print(f"构建 VersionJson 时发生错误: {e}")
