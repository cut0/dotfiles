-- WezTermのキーバインド設定ファイル
-- 各種ショートカットキーの定義をモジュール化
local wezterm = require 'wezterm'
local act = wezterm.action

return {
  -- 通常モードでのキーバインド設定
  keys = {
    -- タブの切り替え
    { key = 'Tab',        mods = 'CTRL',           action = act.ActivateTabRelative(1) },  -- 次のタブへ
    { key = 'Tab',        mods = 'SHIFT|CTRL',     action = act.ActivateTabRelative(-1) }, -- 前のタブへ
    
    -- Alt+Enter: フルスクリーンの切り替え
    { key = 'Enter',      mods = 'ALT',            action = act.ToggleFullScreen },
    
    -- 数字キーでタブの直接切り替え（Ctrl+1で1番目のタブへ）
    -- 大文字・小文字両方に対応して確実な動作を保証
    { key = '!',          mods = 'CTRL',           action = act.ActivateTab(0) },
    { key = '!',          mods = 'SHIFT|CTRL',     action = act.ActivateTab(0) },
    
    -- Alt+Ctrl+": 垂直分割（ペインを縦に分ける）
    { key = '\"',         mods = 'ALT|CTRL',       action = act.SplitVertical { domain = 'CurrentPaneDomain' } },
    { key = '\"',         mods = 'SHIFT|ALT|CTRL', action = act.SplitVertical { domain = 'CurrentPaneDomain' } },
    
    -- タブ番号での切り替え（Ctrl+3で3番目のタブへ）
    { key = '#',          mods = 'CTRL',           action = act.ActivateTab(2) },
    { key = '#',          mods = 'SHIFT|CTRL',     action = act.ActivateTab(2) },
    { key = '$',          mods = 'CTRL',           action = act.ActivateTab(3) },
    { key = '$',          mods = 'SHIFT|CTRL',     action = act.ActivateTab(3) },
    { key = '%',          mods = 'CTRL',           action = act.ActivateTab(4) },
    { key = '%',          mods = 'SHIFT|CTRL',     action = act.ActivateTab(4) },
    
    -- Alt+Ctrl+%: 水平分割（ペインを横に分ける）
    { key = '%',          mods = 'ALT|CTRL',       action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },
    { key = '%',          mods = 'SHIFT|ALT|CTRL', action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },
    
    { key = '&',          mods = 'CTRL',           action = act.ActivateTab(6) },
    { key = '&',          mods = 'SHIFT|CTRL',     action = act.ActivateTab(6) },
    { key = '\'',         mods = 'SHIFT|ALT|CTRL', action = act.SplitVertical { domain = 'CurrentPaneDomain' } },
    
    -- Ctrl+9: 最後のタブへ移動
    { key = '(',          mods = 'CTRL',           action = act.ActivateTab(-1) },
    { key = '(',          mods = 'SHIFT|CTRL',     action = act.ActivateTab(-1) },
    
    -- フォントサイズのリセット
    { key = ')',          mods = 'CTRL',           action = act.ResetFontSize },
    { key = ')',          mods = 'SHIFT|CTRL',     action = act.ResetFontSize },
    
    { key = '*',          mods = 'CTRL',           action = act.ActivateTab(7) },
    { key = '*',          mods = 'SHIFT|CTRL',     action = act.ActivateTab(7) },
    
    -- フォントサイズの調整
    { key = '+',          mods = 'CTRL',           action = act.IncreaseFontSize },    -- Ctrl++: 拡大
    { key = '+',          mods = 'SHIFT|CTRL',     action = act.IncreaseFontSize },
    { key = '-',          mods = 'CTRL',           action = act.DecreaseFontSize },    -- Ctrl+-: 縮小
    { key = '-',          mods = 'SHIFT|CTRL',     action = act.DecreaseFontSize },
    { key = '-',          mods = 'SUPER',          action = act.DecreaseFontSize },    -- Cmd+-: macOS用
    { key = '0',          mods = 'CTRL',           action = act.ResetFontSize },       -- Ctrl+0: リセット
    { key = '0',          mods = 'SHIFT|CTRL',     action = act.ResetFontSize },
    { key = '0',          mods = 'SUPER',          action = act.ResetFontSize },       -- Cmd+0: macOS用
    
    -- 数字キーでのタブ切り替え（1-9）
    { key = '1',          mods = 'SHIFT|CTRL',     action = act.ActivateTab(0) },
    { key = '1',          mods = 'SUPER',          action = act.ActivateTab(0) },
    { key = '2',          mods = 'SHIFT|CTRL',     action = act.ActivateTab(1) },
    { key = '2',          mods = 'SUPER',          action = act.ActivateTab(1) },
    { key = '3',          mods = 'SHIFT|CTRL',     action = act.ActivateTab(2) },
    { key = '3',          mods = 'SUPER',          action = act.ActivateTab(2) },
    { key = '4',          mods = 'SHIFT|CTRL',     action = act.ActivateTab(3) },
    { key = '4',          mods = 'SUPER',          action = act.ActivateTab(3) },
    { key = '5',          mods = 'SHIFT|CTRL',     action = act.ActivateTab(4) },
    { key = '5',          mods = 'SHIFT|ALT|CTRL', action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },
    { key = '5',          mods = 'SUPER',          action = act.ActivateTab(4) },
    { key = '6',          mods = 'SHIFT|CTRL',     action = act.ActivateTab(5) },
    { key = '6',          mods = 'SUPER',          action = act.ActivateTab(5) },
    { key = '7',          mods = 'SHIFT|CTRL',     action = act.ActivateTab(6) },
    { key = '7',          mods = 'SUPER',          action = act.ActivateTab(6) },
    { key = '8',          mods = 'SHIFT|CTRL',     action = act.ActivateTab(7) },
    { key = '8',          mods = 'SUPER',          action = act.ActivateTab(7) },
    { key = '9',          mods = 'SHIFT|CTRL',     action = act.ActivateTab(-1) },
    { key = '9',          mods = 'SUPER',          action = act.ActivateTab(-1) },
    
    -- フォントサイズ調整（=キー）
    { key = '=',          mods = 'CTRL',           action = act.IncreaseFontSize },
    { key = '=',          mods = 'SHIFT|CTRL',     action = act.IncreaseFontSize },
    { key = '=',          mods = 'SUPER',          action = act.IncreaseFontSize },
    
    { key = '@',          mods = 'CTRL',           action = act.ActivateTab(1) },
    { key = '@',          mods = 'SHIFT|CTRL',     action = act.ActivateTab(1) },
    
    -- コピー＆ペースト
    { key = 'C',          mods = 'CTRL',           action = act.CopyTo 'Clipboard' },   -- Ctrl+C: コピー
    { key = 'C',          mods = 'SHIFT|CTRL',     action = act.CopyTo 'Clipboard' },
    
    -- Ctrl+F: 検索機能
    { key = 'F',          mods = 'CTRL',           action = act.Search 'CurrentSelectionOrEmptyString' },
    { key = 'F',          mods = 'SHIFT|CTRL',     action = act.Search 'CurrentSelectionOrEmptyString' },
    
    -- アプリケーション操作
    { key = 'H',          mods = 'CTRL',           action = act.HideApplication },     -- アプリを隠す
    { key = 'H',          mods = 'SHIFT|CTRL',     action = act.HideApplication },
    
    -- Ctrl+K: スクロールバックをクリア（画面をクリーンに）
    { key = 'K',          mods = 'CTRL',           action = act.ClearScrollback 'ScrollbackOnly' },
    { key = 'K',          mods = 'SHIFT|CTRL',     action = act.ClearScrollback 'ScrollbackOnly' },
    
    -- デバッグオーバーレイ表示
    { key = 'L',          mods = 'CTRL',           action = act.ShowDebugOverlay },
    { key = 'L',          mods = 'SHIFT|CTRL',     action = act.ShowDebugOverlay },
    
    { key = 'M',          mods = 'CTRL',           action = act.Hide },
    { key = 'M',          mods = 'SHIFT|CTRL',     action = act.Hide },
    
    -- Ctrl+N: 新しいウィンドウを開く
    { key = 'N',          mods = 'CTRL',           action = act.SpawnWindow },
    { key = 'N',          mods = 'SHIFT|CTRL',     action = act.SpawnWindow },
    
    -- Ctrl+P: コマンドパレットを表示
    { key = 'P',          mods = 'CTRL',           action = act.ActivateCommandPalette },
    { key = 'P',          mods = 'SHIFT|CTRL',     action = act.ActivateCommandPalette },
    
    -- Ctrl+Q: アプリケーションを終了
    { key = 'Q',          mods = 'CTRL',           action = act.QuitApplication },
    { key = 'Q',          mods = 'SHIFT|CTRL',     action = act.QuitApplication },
    
    -- Ctrl+R: 設定を再読み込み
    { key = 'R',          mods = 'CTRL',           action = act.ReloadConfiguration },
    { key = 'R',          mods = 'SHIFT|CTRL',     action = act.ReloadConfiguration },
    
    -- Ctrl+T: 新しいタブを開く
    { key = 'T',          mods = 'CTRL',           action = act.SpawnTab 'CurrentPaneDomain' },
    { key = 'T',          mods = 'SHIFT|CTRL',     action = act.SpawnTab 'CurrentPaneDomain' },
    
    -- Ctrl+U: 特殊文字の選択パネルを表示
    { key = 'U',          mods = 'CTRL',           action = act.CharSelect { copy_on_select = true, copy_to = 'ClipboardAndPrimarySelection' } },
    { key = 'U',          mods = 'SHIFT|CTRL',     action = act.CharSelect { copy_on_select = true, copy_to = 'ClipboardAndPrimarySelection' } },
    
    -- Ctrl+V: ペースト
    { key = 'V',          mods = 'CTRL',           action = act.PasteFrom 'Clipboard' },
    { key = 'V',          mods = 'SHIFT|CTRL',     action = act.PasteFrom 'Clipboard' },
    
    -- Ctrl+W: 現在のタブを閉じる（確認付き）
    { key = 'W',          mods = 'CTRL',           action = act.CloseCurrentTab { confirm = true } },
    { key = 'W',          mods = 'SHIFT|CTRL',     action = act.CloseCurrentTab { confirm = true } },
    
    -- Ctrl+X: コピーモードを起動（Vim風の操作）
    { key = 'X',          mods = 'CTRL',           action = act.ActivateCopyMode },
    { key = 'X',          mods = 'SHIFT|CTRL',     action = act.ActivateCopyMode },
    
    -- Ctrl+Z: ペインのズーム切り替え（全画面表示）
    { key = 'Z',          mods = 'CTRL',           action = act.TogglePaneZoomState },
    { key = 'Z',          mods = 'SHIFT|CTRL',     action = act.TogglePaneZoomState },
    
    -- macOS用タブ切り替え
    { key = '[',          mods = 'SHIFT|SUPER',    action = act.ActivateTabRelative(-1) },
    { key = ']',          mods = 'SHIFT|SUPER',    action = act.ActivateTabRelative(1) },
    
    { key = '^',          mods = 'CTRL',           action = act.ActivateTab(5) },
    { key = '^',          mods = 'SHIFT|CTRL',     action = act.ActivateTab(5) },
    { key = '_',          mods = 'CTRL',           action = act.DecreaseFontSize },
    { key = '_',          mods = 'SHIFT|CTRL',     action = act.DecreaseFontSize },
    
    -- 小文字版のコマンド（大文字と同じ動作）
    { key = 'c',          mods = 'SHIFT|CTRL',     action = act.CopyTo 'Clipboard' },
    { key = 'c',          mods = 'SUPER',          action = act.CopyTo 'Clipboard' },
    { key = 'f',          mods = 'SHIFT|CTRL',     action = act.Search 'CurrentSelectionOrEmptyString' },
    { key = 'f',          mods = 'SUPER',          action = act.Search 'CurrentSelectionOrEmptyString' },
    { key = 'h',          mods = 'SHIFT|CTRL',     action = act.HideApplication },
    { key = 'h',          mods = 'SUPER',          action = act.HideApplication },
    { key = 'k',          mods = 'SHIFT|CTRL',     action = act.ClearScrollback 'ScrollbackOnly' },
    { key = 'k',          mods = 'SUPER',          action = act.ClearScrollback 'ScrollbackOnly' },
    { key = 'l',          mods = 'SHIFT|CTRL',     action = act.ShowDebugOverlay },
    { key = 'm',          mods = 'SHIFT|CTRL',     action = act.Hide },
    { key = 'm',          mods = 'SUPER',          action = act.Hide },
    { key = 'n',          mods = 'SHIFT|CTRL',     action = act.SpawnWindow },
    { key = 'n',          mods = 'SUPER',          action = act.SpawnWindow },
    { key = 'p',          mods = 'SHIFT|CTRL',     action = act.ActivateCommandPalette },
    { key = 'q',          mods = 'SHIFT|CTRL',     action = act.QuitApplication },
    { key = 'q',          mods = 'SUPER',          action = act.QuitApplication },
    { key = 'r',          mods = 'SHIFT|CTRL',     action = act.ReloadConfiguration },
    { key = 'r',          mods = 'SUPER',          action = act.ReloadConfiguration },
    { key = 't',          mods = 'SHIFT|CTRL',     action = act.SpawnTab 'CurrentPaneDomain' },
    { key = 't',          mods = 'SUPER',          action = act.SpawnTab 'CurrentPaneDomain' },
    { key = 'u',          mods = 'SHIFT|CTRL',     action = act.CharSelect { copy_on_select = true, copy_to = 'ClipboardAndPrimarySelection' } },
    { key = 'v',          mods = 'SHIFT|CTRL',     action = act.PasteFrom 'Clipboard' },
    { key = 'v',          mods = 'SUPER',          action = act.PasteFrom 'Clipboard' },
    { key = 'w',          mods = 'SHIFT|CTRL',     action = act.CloseCurrentTab { confirm = true } },
    { key = 'w',          mods = 'SUPER',          action = act.CloseCurrentTab { confirm = true } },
    { key = 'x',          mods = 'SHIFT|CTRL',     action = act.ActivateCopyMode },
    { key = 'z',          mods = 'SHIFT|CTRL',     action = act.TogglePaneZoomState },
    
    -- macOS用の追加ショートカット
    { key = '{',          mods = 'SUPER',          action = act.ActivateTabRelative(-1) },
    { key = '{',          mods = 'SHIFT|SUPER',    action = act.ActivateTabRelative(-1) },
    { key = '}',          mods = 'SUPER',          action = act.ActivateTabRelative(1) },
    { key = '}',          mods = 'SHIFT|SUPER',    action = act.ActivateTabRelative(1) },
    
    -- クイック選択モード
    { key = 'phys:Space', mods = 'SHIFT|CTRL',     action = act.QuickSelect },
    
    -- ページスクロール
    { key = 'PageUp',     mods = 'SHIFT',          action = act.ScrollByPage(-1) },
    { key = 'PageUp',     mods = 'CTRL',           action = act.ActivateTabRelative(-1) },
    { key = 'PageUp',     mods = 'SHIFT|CTRL',     action = act.MoveTabRelative(-1) },
    { key = 'PageDown',   mods = 'SHIFT',          action = act.ScrollByPage(1) },
    { key = 'PageDown',   mods = 'CTRL',           action = act.ActivateTabRelative(1) },
    { key = 'PageDown',   mods = 'SHIFT|CTRL',     action = act.MoveTabRelative(1) },
    
    -- ペインの移動とサイズ調整
    { key = 'LeftArrow',  mods = 'SHIFT|CTRL',     action = act.ActivatePaneDirection 'Left' },   -- 左のペインへ
    { key = 'LeftArrow',  mods = 'SHIFT|ALT|CTRL', action = act.AdjustPaneSize { 'Left', 1 } },   -- ペインサイズ調整
    { key = 'RightArrow', mods = 'SHIFT|CTRL',     action = act.ActivatePaneDirection 'Right' },  -- 右のペインへ
    { key = 'RightArrow', mods = 'SHIFT|ALT|CTRL', action = act.AdjustPaneSize { 'Right', 1 } },
    { key = 'UpArrow',    mods = 'SHIFT|CTRL',     action = act.ActivatePaneDirection 'Up' },     -- 上のペインへ
    { key = 'UpArrow',    mods = 'SHIFT|ALT|CTRL', action = act.AdjustPaneSize { 'Up', 1 } },
    { key = 'DownArrow',  mods = 'SHIFT|CTRL',     action = act.ActivatePaneDirection 'Down' },   -- 下のペインへ
    { key = 'DownArrow',  mods = 'SHIFT|ALT|CTRL', action = act.AdjustPaneSize { 'Down', 1 } },
    
    -- 特殊キー
    { key = 'Copy',       mods = 'NONE',           action = act.CopyTo 'Clipboard' },
    { key = 'Paste',      mods = 'NONE',           action = act.PasteFrom 'Clipboard' },
  },

  -- 特殊モードでのキーバインド設定
  key_tables = {
    -- コピーモード（Vim風の操作）
    copy_mode = {
      { key = 'Tab',        mods = 'NONE',  action = act.CopyMode 'MoveForwardWord' },
      { key = 'Tab',        mods = 'SHIFT', action = act.CopyMode 'MoveBackwardWord' },
      { key = 'Enter',      mods = 'NONE',  action = act.CopyMode 'MoveToStartOfNextLine' },
      { key = 'Escape',     mods = 'NONE',  action = act.CopyMode 'Close' },           -- Esc: モード終了
      { key = 'Space',      mods = 'NONE',  action = act.CopyMode { SetSelectionMode = 'Cell' } }, -- 選択開始
      { key = '$',          mods = 'NONE',  action = act.CopyMode 'MoveToEndOfLineContent' }, -- 行末へ
      { key = '$',          mods = 'SHIFT', action = act.CopyMode 'MoveToEndOfLineContent' },
      { key = ',',          mods = 'NONE',  action = act.CopyMode 'JumpReverse' },
      { key = '0',          mods = 'NONE',  action = act.CopyMode 'MoveToStartOfLine' },   -- 行頭へ
      { key = ';',          mods = 'NONE',  action = act.CopyMode 'JumpAgain' },
      { key = 'F',          mods = 'NONE',  action = act.CopyMode { JumpBackward = { prev_char = false } } },
      { key = 'F',          mods = 'SHIFT', action = act.CopyMode { JumpBackward = { prev_char = false } } },
      { key = 'G',          mods = 'NONE',  action = act.CopyMode 'MoveToScrollbackBottom' }, -- 最下部へ
      { key = 'G',          mods = 'SHIFT', action = act.CopyMode 'MoveToScrollbackBottom' },
      { key = 'H',          mods = 'NONE',  action = act.CopyMode 'MoveToViewportTop' },
      { key = 'H',          mods = 'SHIFT', action = act.CopyMode 'MoveToViewportTop' },
      { key = 'L',          mods = 'NONE',  action = act.CopyMode 'MoveToViewportBottom' },
      { key = 'L',          mods = 'SHIFT', action = act.CopyMode 'MoveToViewportBottom' },
      { key = 'M',          mods = 'NONE',  action = act.CopyMode 'MoveToViewportMiddle' },
      { key = 'M',          mods = 'SHIFT', action = act.CopyMode 'MoveToViewportMiddle' },
      { key = 'O',          mods = 'NONE',  action = act.CopyMode 'MoveToSelectionOtherEndHoriz' },
      { key = 'O',          mods = 'SHIFT', action = act.CopyMode 'MoveToSelectionOtherEndHoriz' },
      { key = 'T',          mods = 'NONE',  action = act.CopyMode { JumpBackward = { prev_char = true } } },
      { key = 'T',          mods = 'SHIFT', action = act.CopyMode { JumpBackward = { prev_char = true } } },
      { key = 'V',          mods = 'NONE',  action = act.CopyMode { SetSelectionMode = 'Line' } }, -- 行選択
      { key = 'V',          mods = 'SHIFT', action = act.CopyMode { SetSelectionMode = 'Line' } },
      { key = '^',          mods = 'NONE',  action = act.CopyMode 'MoveToStartOfLineContent' },
      { key = '^',          mods = 'SHIFT', action = act.CopyMode 'MoveToStartOfLineContent' },
      { key = 'b',          mods = 'NONE',  action = act.CopyMode 'MoveBackwardWord' }, -- 前の単語へ
      { key = 'b',          mods = 'ALT',   action = act.CopyMode 'MoveBackwardWord' },
      { key = 'b',          mods = 'CTRL',  action = act.CopyMode 'PageUp' },
      { key = 'c',          mods = 'CTRL',  action = act.CopyMode 'Close' },
      { key = 'd',          mods = 'CTRL',  action = act.CopyMode { MoveByPage = (0.5) } },
      { key = 'e',          mods = 'NONE',  action = act.CopyMode 'MoveForwardWordEnd' },
      { key = 'f',          mods = 'NONE',  action = act.CopyMode { JumpForward = { prev_char = false } } },
      { key = 'f',          mods = 'ALT',   action = act.CopyMode 'MoveForwardWord' },
      { key = 'f',          mods = 'CTRL',  action = act.CopyMode 'PageDown' },
      { key = 'g',          mods = 'NONE',  action = act.CopyMode 'MoveToScrollbackTop' },   -- 最上部へ
      { key = 'g',          mods = 'CTRL',  action = act.CopyMode 'Close' },
      -- Vim風のカーソル移動
      { key = 'h',          mods = 'NONE',  action = act.CopyMode 'MoveLeft' },    -- 左へ
      { key = 'j',          mods = 'NONE',  action = act.CopyMode 'MoveDown' },    -- 下へ
      { key = 'k',          mods = 'NONE',  action = act.CopyMode 'MoveUp' },      -- 上へ
      { key = 'l',          mods = 'NONE',  action = act.CopyMode 'MoveRight' },   -- 右へ
      { key = 'm',          mods = 'ALT',   action = act.CopyMode 'MoveToStartOfLineContent' },
      { key = 'o',          mods = 'NONE',  action = act.CopyMode 'MoveToSelectionOtherEnd' },
      { key = 'q',          mods = 'NONE',  action = act.CopyMode 'Close' },
      { key = 't',          mods = 'NONE',  action = act.CopyMode { JumpForward = { prev_char = true } } },
      { key = 'u',          mods = 'CTRL',  action = act.CopyMode { MoveByPage = (-0.5) } },
      { key = 'v',          mods = 'NONE',  action = act.CopyMode { SetSelectionMode = 'Cell' } }, -- 文字選択
      { key = 'v',          mods = 'CTRL',  action = act.CopyMode { SetSelectionMode = 'Block' } },
      { key = 'w',          mods = 'NONE',  action = act.CopyMode 'MoveForwardWord' },  -- 次の単語へ
      { key = 'y',          mods = 'NONE',  action = act.Multiple { { CopyTo = 'Clipboard' }, { CopyMode = 'Close' } } }, -- コピーして終了
      { key = 'PageUp',     mods = 'NONE',  action = act.CopyMode 'PageUp' },
      { key = 'PageDown',   mods = 'NONE',  action = act.CopyMode 'PageDown' },
      { key = 'End',        mods = 'NONE',  action = act.CopyMode 'MoveToEndOfLineContent' },
      { key = 'Home',       mods = 'NONE',  action = act.CopyMode 'MoveToStartOfLine' },
      { key = 'LeftArrow',  mods = 'NONE',  action = act.CopyMode 'MoveLeft' },
      { key = 'LeftArrow',  mods = 'ALT',   action = act.CopyMode 'MoveBackwardWord' },
      { key = 'RightArrow', mods = 'NONE',  action = act.CopyMode 'MoveRight' },
      { key = 'RightArrow', mods = 'ALT',   action = act.CopyMode 'MoveForwardWord' },
      { key = 'UpArrow',    mods = 'NONE',  action = act.CopyMode 'MoveUp' },
      { key = 'DownArrow',  mods = 'NONE',  action = act.CopyMode 'MoveDown' },
    },

    -- 検索モード
    search_mode = {
      { key = 'Enter',     mods = 'NONE', action = act.CopyMode 'PriorMatch' },      -- 前の一致へ
      { key = 'Escape',    mods = 'NONE', action = act.CopyMode 'Close' },           -- 検索を終了
      { key = 'n',         mods = 'CTRL', action = act.CopyMode 'NextMatch' },       -- 次の一致へ
      { key = 'p',         mods = 'CTRL', action = act.CopyMode 'PriorMatch' },      -- 前の一致へ
      { key = 'r',         mods = 'CTRL', action = act.CopyMode 'CycleMatchType' },  -- 検索タイプ切り替え
      { key = 'u',         mods = 'CTRL', action = act.CopyMode 'ClearPattern' },    -- 検索パターンをクリア
      { key = 'PageUp',    mods = 'NONE', action = act.CopyMode 'PriorMatchPage' },
      { key = 'PageDown',  mods = 'NONE', action = act.CopyMode 'NextMatchPage' },
      { key = 'UpArrow',   mods = 'NONE', action = act.CopyMode 'PriorMatch' },
      { key = 'DownArrow', mods = 'NONE', action = act.CopyMode 'NextMatch' },
    },

  }
}
