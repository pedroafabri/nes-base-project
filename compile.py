import os
import subprocess

for filename in os.listdir("src"):
    if filename.endswith(".asm"):
        outputName = os.path.splitext(filename)[0] + ".o"
        command = "ca65 src/{0} -o output/{1}".format(filename, outputName)
        print(subprocess.run(command))

command = "ld65 ./*.o -C nes.cfg -o output/rom/main.nes"

try:
    subprocess.check_output(command ,shell=True,stderr=subprocess.STDOUT)
except subprocess.CalledProcessError as e:
    print("command '{}' return with error (code {}): {}".format(e.cmd, e.returncode, e.output))
