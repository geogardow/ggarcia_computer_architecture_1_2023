import subprocess
import time

file = "algorithmWithOutReverb"

comp = ["arm-none-eabi-as", file+".s", "-g", "-o", file+".o"]
link = ["arm-none-eabi-ld", file+".o", "-o", file]

subprocess.Popen(comp).wait()
subprocess.Popen(link).wait()

# Ejecutar de qemu en el puerto 8080
qemu_command = ["qemu-arm", "-singlestep", "-g", "8080", file]

# Ejecutar GDB y conectarlo al puerto 8080
gdb_commands = ["gdb-multiarch", "-tui",
                file, "-ex", "target remote localhost:8080"]

# Ejecuta QEMU en un proceso separado
qemu_process = subprocess.Popen(qemu_command)
time.sleep(1)

# Ejecuta GDB en un proceso separado y lo conecta a QEMU
gdb_process = subprocess.Popen(gdb_commands)

# Espera a que ambos procesos finalicen
qemu_process.wait()
gdb_process.wait()
