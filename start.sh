#!/bin/bash

# start.sh
# Ollamaコンテナを起動し、ユーザーがLLMモデルをダウンロードするか、
# 対話形式でOllamaを実行するかを選択できる

CONTAINER_NAME="ollama-gpt-oss"
INSTALL_SCRIPT="./llm_install_to_container.sh"

# コンテナが起動しているか確認
if ! docker ps | grep -q "$CONTAINER_NAME"; then
    echo "コンテナ '$CONTAINER_NAME' が起動していません。起動します..."
    docker start "$CONTAINER_NAME"
    # コンテナが完全に起動するまで少し待つ
    sleep 5
fi

echo "Ollamaコンテナ起動中"
echo "選択して"
echo "1) LLMモデルをダウンロード"
echo "2) 対話形式でOllamaを実行.デフォルトはgpt-oss:20b"
echo "3) gpt-oss:20b以外のモデルを指定して実行"
echo "4) 終了"

read -rp "選択してください (1/2/3/4): " choice

case $choice in
    1)
        echo "環境構築を開始。モデル名を入力。使用できるモデルはollamaサイトを参照。 URL:https://ollama.com/library"
        "$INSTALL_SCRIPT"
        ;;
    2)
        echo "対話形式でOllamaを実行。終了するには 'exit' と入力"
        docker exec -it "$CONTAINER_NAME" ollama run gpt-oss:20b
        ;;
    3)
        read -rp "使用するモデル名を入力してください (例: gpt-oss:20b): " model_name
        echo "指定されたモデル '$model_name' で実行。終了するには 'exit' と入力。"
        docker exec -it "$CONTAINER_NAME" ollama run "$model_name"
        ;;
    4)
        echo "スクリプトを終了します。"
        exit 0
        ;;
    *)
        echo "無効な選択です。スクリプトを終了します。"
        exit 1
        ;;
esac

echo "処理が完了しました。"
