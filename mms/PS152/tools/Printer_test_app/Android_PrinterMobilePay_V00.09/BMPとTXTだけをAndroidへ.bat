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
..\adb shell rm /sdcard/pictures/PATTERN1.bmp
..\adb shell rm /sdcard/pictures/PATTERN2.bmp
..\adb shell rm /sdcard/pictures/PATTERN3.bmp
..\adb shell rm /sdcard/pictures/PATTERN4.bmp
..\adb shell rm /sdcard/pictures/PATTERN5.bmp
rem �r�b�g�}�b�v�t�@�C�����R�s�[����
..\adb push PATTERN1.bmp /sdcard/Pictures/
..\adb push PATTERN2.bmp /sdcard/Pictures/
..\adb push PATTERN3.bmp /sdcard/Pictures/
..\adb push PATTERN4.bmp /sdcard/Pictures/
..\adb push PATTERN5.bmp /sdcard/Pictures/

ECHO ���{��t�H���g�t�@�C�����R�s�[���܂��B
..\adb shell rm /sdcard/pictures/PRN_FT01.bin
..\adb push PRN_FT01.bin /sdcard/Pictures/

ECHO �t�@�[���E�F�A�f�[�^�]���p�t�@�C�����R�s�[���܂�
..\adb shell rm /sdcard/pictures/MobilePay.bin
..\adb push MobilePay.bin /sdcard/Pictures/

ECHO iowrite.txt�f�[�^���R�s�[���܂�
..\adb shell rm /sdcard/pictures/iowrite.txt
..\adb push iowrite.txt /sdcard/Pictures/

ECHO spiwrite.txt�f�[�^���R�s�[���܂�
..\adb shell rm /sdcard/pictures/spiwrite.txt
..\adb push spiwrite.txt /sdcard/Pictures/

ECHO TEXT1.txt TEXT2.txt TEXT3.txt�f�[�^���R�s�[���܂�
..\adb shell rm /sdcard/pictures/TEXT1.txt
..\adb shell rm /sdcard/pictures/TEXT2.txt
..\adb shell rm /sdcard/pictures/TEXT3.txt
..\adb push TEXT1.txt /sdcard/Pictures/
..\adb push TEXT2.txt /sdcard/Pictures/
..\adb push TEXT3.txt /sdcard/Pictures/

rem /* +++ JMups Addition Start by 2014/06/05 f.ono +++ */
rem ECHO Printer�A�v���P�[�V�������R�s�[���܂��B
rem ..\adb shell rm /sdcard/pictures/Printer.apk
rem ..\adb push Printer.apk /sdcard/Pictures/

rem ECHO �����[�X�m�[�g���R�s�[�]�����Ă����܂��B
rem ..\adb shell rm /sdcard/pictures/ReleaseNote.txt
rem ..\adb push ReleaseNote.txt /sdcard/Pictures/

rem ECHO Printer.apk���C���X�g�[�����܂�
rem ..\adb uninstall com.example.printer
rem ..\adb install Printer.apk
rem /* +++ JMups Addition End   by 2014/06/05 f.ono +++ */

ECHO �C���X�g�[���́A����ɏI�����܂���

pause
