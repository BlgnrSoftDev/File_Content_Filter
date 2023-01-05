#! /usr/bin/bash

whiptail --title "Dosya Okuyucu" --msgbox "Programa Hoşgeldiniz, bu program seçtiğiniz bir dosyanın belirttiğiniz satırlarını ekran arayüzünde gösterir." 10 100

filename=$(whiptail --inputbox "Görüntülemek İstediğiniz Dosyanın Adını Giriniz?" 10 100 --title "Dosya Seç" 3>&1 1>&2 2>&3)
exitstatus=$?

if (( $exitstatus == 0 )); then
    if [[ -s $filename ]]; then
        filesize=$( wc -l $filename )
        read param1 param2 <<< $filesize
        filesize=$param1

        control=0
        while (( control == 0 ))
        do
            start=$(whiptail --inputbox "Görüntülemek İçin Başlangıç Satırını Giriniz?" 10 100 1 --title "İçerik Filtreleme" 3>&1 1>&2 2>&3)
            exitstatus=$?
            if (( $exitstatus == 0 )); then
                end=$(whiptail --inputbox "Görüntülemek İçin Bitiş Satırını Giriniz?" 10 100 $filesize --title "İçerik Filtreleme" 3>&1 1>&2 2>&3)
                exitstatus=$?
                if (( $exitstatus == 0 )); then
                    if (( end <= filesize && start >= 1 )); then
                        up=$(( filesize - start + 1 ))
                        down=$(( up + end - filesize - 1))
                        eval "tail -${up} $filename | head -${down} > temp.txt"
                        # str=$( < ${filename}.txt )
                        whiptail --textbox temp.txt 40 100 --scrolltext
                        eval "rm temp.txt"
                    else 
                        whiptail --title "Hata" --msgbox "Lütfen Belirtilen Sınırlar İçerisinde Filtreleme Yapınız: min:1, max:$filesize" 10 100                    
                    fi
                else
                    echo "Kullanıcı Cancela tıklarsa"
                    control=1
                fi
            else 
                echo "kullanıcı cancel'a tıklarsa"
                control=1
            fi
        done
    else 
        whiptail --title "Hata" --msgbox "Girdiğiniz İsimde Herhangi bir Dosya Bulunamadı,  Program Dışına Yönlendiriliyorsunuz... " 10 100
        control=1
    fi
else # Kullanıcı dosya seçme ekranında cancel butonuna tıklarsa
    echo "User selected Cancel."
fi

