---
name: typescript
description: |
  JavaScript および TypeScript プロジェクトのコーディングルールを提供します。
  JS/TS のコードを書く際に自動的にトリガーされます。
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

## テストルール

- テストの `describe` と `it` の説明文は日本語で書く
- テストファイル名は `*.test.ts` とする

```typescript
// ✅ OK
describe("createFormatAsJsonUsecase", () => {
  it("有効な JSON 文字列を返す", () => {
    // ...
  });

  it("すべてのサマリーフィールドを含む", () => {
    // ...
  });
});

// ❌ NG
describe("createFormatAsJsonUsecase", () => {
  it("should return valid JSON string", () => {
    // ...
  });
});
```

