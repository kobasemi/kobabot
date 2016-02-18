# Description:
#   Show help of Slack
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot slack help - Show help of Slack
#
# Author:
#   Trileg

module.exports = (robot) ->
  robot.respond /slack help/i, (msg) ->
    response = """
      以下のコマンド文字について，前後に別の文字列がある場合は半角スペースを一つずつ入れること
      Sample: `foo *var* val`

      太字: 対象の文字列をアスタリスク `*` で囲む
      斜字: 対象の文字列をアンダーバー `_` で囲む
      取り消し線: 対象の文字列をチルダ `~` で囲む
      一行引用: 先頭に閉じ山括弧 `>`
      複数行引用: 一行目の先頭に閉じ山括弧を三つ `>>>`
      インラインコード: 対象の文字列をバッククォートで囲む
      コードブロック: 対象の文字列をバッククォート三つで囲む
    """
    msg.send response
