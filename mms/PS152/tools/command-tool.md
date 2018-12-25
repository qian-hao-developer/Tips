# 次のコマンドを打てばQDLoaderにすることは可能です。
    fastboot erase sbl1

# NV

ID |	意味 |	値
===
| 2556 | fastbootモード                          | 0x00：OFF、0x01：ON                                               |
| 2557 | 工程（FTM）モード 	0x00：FTM、以外：業務 |                                                                   |
| 2558 | Diagポート                              | 0x00：ON、0x01：OFF                                               |
| 2571 | FOTA書き換えフラグ                      | ORDINARY:通常時、RECOVERY:書き換え開始時、COMPLETE:書き換え完了時 |
| 2591 | FOTA用言語設定                          | 0x05:日本語、0x00：英語                                           |
| 2603 | BTアドレス                              | アドレス値。00a0c6XXXXXX                                          |
| 2604 | WLANアドレス                            | アドレス値                                                        |
| 2611 | シリアルナンバー                        | 文字列。ASCIIを16進で入力                                         |

## nvm_test2の使い方

nvm_testとnvm_test2はFTMモード時のみ使用可能
このセクションを編集
読み込み

nvm_test2 1 2591
nvm_test2 1 2571
このセクションを編集
書き込み

nvm_test2 2 2591 05
nvm_test2 2 2571 4F/52/44/49/4E/41/52/59
このセクションを編集
初期化

nvm_test2 3 1 (all area:read/write and WORM area) ※危険
nvm_test2 3 2 (partial area:read/write area) ※通常はこれを使用
nvm_test2 3 3 (only WORM area) ※危険

# 不揮発の初期化
## nvm_test2経由

nvm_test2 3 1   (BRB)
nvm_test2 3 2   (nvm_test2の使い方を参考)

## fastboot (recommanded)

fastboot getvar NVM-COMMAND_init_1
