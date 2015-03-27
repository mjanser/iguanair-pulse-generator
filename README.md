# iguanaIR pulse generator #

[iguanaIR](http://www.iguanaworks.net/) can use text files to send IR signals to other devices.
Such a text file contains a list of pulse and space lengths. You can record one with the following command
and sending some IR signal to the iguanaIR.

    igclient --receiver-on --sleep 10 >signals.txt

This will record the signals for 10 seconds and put them into the file `signals.txt`.
This file looks similar to this:

    space 152917
    space 152917
    space 95573
    space 8768
    pulse 8960
    space 4416
    pulse 554
    space 1621
    pulse 554
    space 490
    ...
    pulse 554
    space 1621
    pulse 554
    space 43690
    space 152917
    space 152917

The lines with `space 152917` can be ignored because this is iguanaIR waiting for a signal.
The file contains this information:

- Header signals to define the start (`pulse 8960, space 4416`)
- Tail signals to define the end (`pulse 554, space 43690`)
- Definition of binary 1 (`pulse 554, space 1621`)
- Definition of binary 0 (`pulse 554, space 490`)

To find out which is binary 1 and which is binary 0 you have to try or look at the documentation. If the signals
are defined by hex numbers, convert them to binary and compare it to the recorded signals (maybe also in reverse order).
The numbers behind `pulse` and `space` don't have to be always the same and can vary a little bit.

Now you could record the signals for all the buttons on the remote and use these files.
But if you have the documentation of the remote with hex numbers for each button there is an easier way.
In this case you can use the script `generate.bash` in this repository.

    ./generate.bash -1 ONE_DEF -0 ZERO_DEF [-h HEADER_DEF] [-t TAIL_DEF] [-v VENDOR_HEX] [-r] COMMAND_HEX

The definition for binary 1 and 0, header and tail you get from the previous recording. They have to be defined by
a list of pulse and space lengths separated by whitespace.

Some remotes send the signals in reverse order, then you should pass the `-r` option.

If you save the output into a file, you can send that using `igclient`.

    igclient --send=signals.txt
