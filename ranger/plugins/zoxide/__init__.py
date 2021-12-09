import os.path
import itertools
import ranger.api
import ranger.core.fm
import ranger.ext.signals
from subprocess import Popen, PIPE, run

hook_init_prev = ranger.api.hook_init


def hook_init(fm):
    def zoxide_add(signal):
        Popen(["zoxide", "add", signal.new.path])

    fm.signal_bind("cd", zoxide_add)
    fm.commands.alias("zi", "z -i")
    return hook_init_prev(fm)


ranger.api.hook_init = hook_init


class z(ranger.config.commands.cd):
    """
    :z

    Jump around with zoxide (z)
    """

    def execute(self):
        if self.arg(1) == "-i":
            results = self.query(self.args[1:])
            if not results:
                return
            if os.path.isdir(results[0]):
                self.fm.cd(results[0])
            return
        super().execute()

    def query(self, args):
        try:
            zoxide = self.fm.execute_command(
                f"zoxide query {' '.join(self.args[1:])}",
                stdout=PIPE,  # add stdout=PIPE causes interactive mode broken
            )
            stdout, stderr = zoxide.communicate()

            if zoxide.returncode == 0:
                output = stdout.decode("utf-8").strip()
                return output.splitlines()
            elif zoxide.returncode == 1:  # nothing found
                return None
            elif zoxide.returncode == 130:  # user cancelled
                return None
            else:
                output = (
                    stderr.decode("utf-8").strip()
                    or f"zoxide: unexpected error (exit code {zoxide.returncode})"
                )
                self.fm.notify(output, bad=True)
        except Exception as e:
            self.fm.notify(e, bad=True)

    # return types:
    # 1. str for signal result
    # 2. list
    # 3. iterator for large result
    def tab(self, tabnum):
        results = self.query(self.args[1:]) or []
        results = ["z {}/".format(x) for x in results]

        cd_results = super().tab(tabnum) or []

        # no match in zoxide
        if len(results) == 0:
            return cd_results
        # only match in zoxide, no match in children dir
        if len(results) == 1 and not cd_results:
            return results[0]

        # both match in zoxide and children dir
        if isinstance(cd_results, str):
            cd_results = [cd_results]

        rtn = itertools.chain(results, cd_results)
        return rtn
