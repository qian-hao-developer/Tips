release-memo

1. manifestをdefaultで、最新のpf_devを取る
2. ビルド（現在ビルドマシンがないため、ローカルで）
3. 焼いて動作確認
4. manifestを追加
    cp .repo/manifests/default.xml .repo/manifests/<新バージョン>.xml
    <新バージョン>.xml内部に、
        修正のあるリポジトリ名
        バージョン
    を修正
5. <新バージョン>.xmlをpush
6. TAGを切る
    repo forall で新バージョンのTAGを全リポジトリで切る
7. repo forall でpush
8. commit差分を取得
    git clone ssh://gitosis@10.68.37.24:22/home/jenkins/local-repo/ps152.git
    pw:gitosis

    diff --git a/commit_list/make_commit_list.yaml b/commit_list/make_commit_list.yaml
    old mode 100644
    new mode 100755
    index 8de768f..5e64654
    --- a/commit_list/make_commit_list.yaml
    +++ b/commit_list/make_commit_list.yaml
    @@ -1,6 +1,6 @@
    -mydroid_dir: /home2/ps152-cobra-release/nightly
    -old_version: ps152-12-C14-106-00
    -new_version: ps152-12-C14-107-00
    +mydroid_dir: /home/ps152-dev/work/ps152osv^M
    +old_version: PS152-15-C30-001-00^M
    +new_version: PS152-15-C30-003-00^M
     add_html_file: 
     show_modify_files: true
     add_message:

    ./commit_list/make_commit_list2.rb
    # add_html_fileは出力パス
9. ps152-3/develop/nightly/ps152o_pf_dev/ にPS152-C30-xxx-xx.zipを配置する
10. リリースメールを発送する（commit差分を添付）