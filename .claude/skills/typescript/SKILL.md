---
name: typescript
description: |
  JavaScript および TypeScript プロジェクトのコーディングルールを提供します。
  React コンポーネントの設計パターンも含みます。
  JS/TS/React のコードを書く際に自動的にトリガーされます。
---

# TypeScript / JavaScript コーディングルール

## 一般パターン

- async/await を使用: Promise チェーンより async/await を優先
- 関数型プログラミング: 可能な限り関数型アプローチを優先
- 配列の破壊的メソッド禁止: push/pop/shift/unshift/splice/sort/reverse を避け、スプレッド構文や map/filter/concat/toSorted/toReversed を使用
- 早期リターン: ネストを減らすため早期リターンを使用
- アロー関数のみ: function キーワードではなくアロー関数を使用
- 戻り値の型注釈: 関数の戻り値には型注釈を必須
- 使用前に宣言: 変数・関数は使用前に宣言
- const をデフォルト: 再代入がない限り const を使用
- 関数内関数を避ける: ネストした関数定義を避ける
- 副作用を避ける: 純粋関数を優先
- 引数3つ以上はオブジェクト: 引数が多い場合はオブジェクトで受け取る
- テストでのモック最小化: モックの使用を最小限に
- const object を使用: enum ではなく const object を使用
- Promise.all で並列処理: 並列処理には Promise.all を使用
- for...of を使用: forEach ではなく for...of を使用
- any 型禁止: any 型の使用禁止
- 非 null アサーション禁止: `!` の使用禁止

## React 固有ルール

### コンポーネント設計

- 関数コンポーネントのみ: クラスコンポーネントは使用しない
- Hooks を使用: 状態管理には Hooks を使用
- 1ファイル1コンポーネント: 複数コンポーネントを1ファイルに入れない
- PascalCase: コンポーネント名は PascalCase
- インラインスタイル禁止: CSS-in-JS またはスタイルシートを使用
- 高コストコンポーネントはメモ化: React.memo を活用
- 配列インデックスを key に使用禁止: 一意な ID を使用

### コンポーネント実装

- 小さく焦点を絞る: 単一責任の原則に従う
- カスタムフックとして抽出: ロジックの再利用には Hook を抽出
- ローディング・エラー状態を処理: 必ず両方の状態をハンドル
- useCallback/useMemo を使用: パフォーマンス最適化
- 制御コンポーネントを優先: フォームは制御コンポーネントとして実装
- 状態を親に引き上げ: 必要に応じて状態をリフトアップ
- 直接的な DOM 操作禁止: React の仕組みを使用

### TypeScript との連携

- 適切な TypeScript 型定義: Props には型を定義
- FC 型を使用: コンポーネントに `React.FC<Props>` で型付け
- 関数は必ず useCallback: イベントハンドラ等は useCallback でラップ

### テストと品質

- Storybook を記載: コンポーネントには Storybook を作成
- Form コンポーネントはテスト作成を確認: フォームはテストについて確認

### アンチパターン

- useEffect 使用禁止: ユーザーの許可がない限り useEffect を使用しない
- 状態を最小化: コンポーネントの状態は必要最小限に
