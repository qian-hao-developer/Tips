@ECHO OFF
ECHO RAW�]���p�r�b�g�}�b�v���R�s�[���܂��B
rem �r�b�g�}�b�v�t�@�C��������
..\adb shell rm /mnt/sdcard/pictures/RAW_PATTERN1.bmp
..\adb shell rm /mnt/sdcard/pictures/RAW_PATTERN2.bmp
..\adb shell rm /mnt/sdcard/pictures/RAW_PATTERN3.bmp
..\adb shell rm /mnt/sdcard/pictures/RAW_PATTERN4.bmp
..\adb shell rm /mnt/sdcard/pictures/RAW_PATTERN5.bmp
rem �r�b�g�}�b�v�t�@�C�����R�s�[����
..\adb push RAW_PATTERN1.bmp /mnt/sdcard/Pictures/
..\adb push RAW_PATTERN2.bmp /mnt/sdcard/Pictures/
..\adb push RAW_PATTERN3.bmp /mnt/sdcard/Pictures/
..\adb push RAW_PATTERN4.bmp /mnt/sdcard/Pictures/
..\adb push RAW_PATTERN5.bmp /mnt/sdcard/Pictures/

ECHO �C���[�W�]���p�r�b�g�}�b�v���R�s�[���܂��B
rem �r�b�g�}�b�v�t�@�C��������
..\adb shell rm /mnt/sdcard/pictures/PATTERN1.bmp
..\adb shell rm /mnt/sdcard/pictures/PATTERN2.bmp
..\adb shell rm /mnt/sdcard/pictures/PATTERN3.bmp
..\adb shell rm /mnt/sdcard/pictures/PATTERN4.bmp
..\adb shell rm /mnt/sdcard/pictures/PATTERN5.bmp
rem �r�b�g�}�b�v�t�@�C�����R�s�[����
..\adb push PATTERN1.bmp /mnt/sdcard/Pictures/
..\adb push PATTERN2.bmp /mnt/sdcard/Pictures/
..\adb push PATTERN3.bmp /mnt/sdcard/Pictures/
..\adb push PATTERN4.bmp /mnt/sdcard/Pictures/
..\adb push PATTERN5.bmp /mnt/sdcard/Pictures/

ECHO ���{��t�H���g�t�@�C�����R�s�[���܂��B
..\adb shell rm /mnt/sdcard/pictures/PRN_FT01.bin
..\adb push PRN_FT01.bin /mnt/sdcard/Pictures/

ECHO �t�@�[���E�F�A�f�[�^�]���p�t�@�C�����R�s�[���܂�
..\adb shell rm /mnt/sdcard/pictures/MobilePay.bin
..\adb push MobilePay.bin /mnt/sdcard/Pictures/

ECHO iowrite.txt�f�[�^���R�s�[���܂�
..\adb shell rm /mnt/sdcard/pictures/iowrite.txt
..\adb push iowrite.txt /mnt/sdcard/Pictures/

ECHO spiwrite.txt�f�[�^���R�s�[���܂�
..\adb shell rm /mnt/sdcard/pictures/spiwrite.txt
..\adb push spiwrite.txt /mnt/sdcard/Pictures/

ECHO TEXT1.txt TEXT2.txt TEXT3.txt�f�[�^���R�s�[���܂�
..\adb shell rm /mnt/sdcard/pictures/TEXT1.txt
..\adb shell rm /mnt/sdcard/pictures/TEXT2.txt
..\adb shell rm /mnt/sdcard/pictures/TEXT3.txt
..\adb push TEXT1.txt /mnt/sdcard/Pictures/
..\adb push TEXT2.txt /mnt/sdcard/Pictures/
..\adb push TEXT3.txt /mnt/sdcard/Pictures/

ECHO Printer�A�v���P�[�V�������R�s�[���܂��B
..\adb shell rm /mnt/sdcard/pictures/PrinterMobilePay.apk
..\adb push PrinterMobilePay.apk /mnt/sdcard/Pictures/

ECHO �����[�X�m�[�g���R�s�[�]�����Ă����܂��B
..\adb shell rm /mnt/sdcard/pictures/ReleaseNote.txt
..\adb push ReleaseNote.txt /mnt/sdcard/Pictures/

ECHO PrinterMobilePay.apk���C���X�g�[�����܂�
..\adb uninstall com.example.printer
..\adb install PrinterMobilePay.apk

ECHO �C���X�g�[���́A����ɏI�����܂���

pause
