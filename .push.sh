#!/bin/bash

DIR="/home/user/Desktop/PND_Solutions"

cd $DIR || exit

git add .
git commit -m "Automatic Commit"
git push


##############################
### per gestire gli errori ###
##############################

if [ $? -ne 0 ]; then
    # Se il codice di uscita non è zero, c'è stato un errore
    echo "Si è verificato un errore con il push"
    scelta=$(zenity --list --title="Errore" \
        --text="Si è verificato un errore con il push, che succede?" \
        --column="Opzioni" "Riprova un push automatico" "Apri un terminale per visualizzare l'errore" "Ignora l'errore" --height=250 --width=300)

    case $scelta in
        "Riprova un push automatico")
            echo "Riprovo il push automatico..."
            /hoome/user/Desktop.push.sh &
            exit 0
            ;;
        "Apri un terminale per visualizzare l'errore")

            # Visto che bash è un po' limitato, per aspettare un terminale aperto tramite gnome-terminal bisogna fare così:
            pid_file="/tmp/git_push_terminal.pid"               # Creo un file temporaneo in cui salvare il pid del nuovo terminale

            # Eseguo un terminale che stampa il suo stesso PID sul file di cui sopra, poi fa quello che deve fare
            gnome-terminal -- bash -c "echo \$\$ > '$pid_file'; cd $DIR || exit; git push; exec bash" &
            sleep 1                                             # Gli serve un momento per fare tutta sta roba, il processore c'ha da fa
            if [ -f "$pid_file" ]; then                         # Se il file temporaneo esiste
                terminal_pid=$(<"$pid_file")                    # Leggi il PID dal file

                # La syscall wait non funziona se il processo da aspettare non è direttamente tuo figlio, quindi...
                while true; do
                    if ! ps -p $terminal_pid > /dev/null; then
                        break  # Esci dal ciclo se il terminale è chiuso
                    fi
                    sleep 1  # Aspetta 1 secondo prima di controllare di nuovo
            done

            rm -f "$pid_file"                                   # Rimuovi il file temporaneo
            else
                echo "Impossibile trovare il file $pid_file."   # Non si sa mai
            fi
            exit 1
            ;;
        "Ignora l'errore")
            echo "Ignoro l'errore e proseguo..."
            exit 0
            ;;
        *)
            notify-send "git push daemon" "Questa scelta equivale a selezionare 'Ignora l'errore'\nNon ignorare i menù a tendina per favore"
            exit 1
            ;;
    esac

else
    echo "git push daemon correctly executed"
    notify-send "git push daemon" "git push daemon correctly executed"
    exit 0
fi
