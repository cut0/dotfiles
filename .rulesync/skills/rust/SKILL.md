---
name: rust
description: |
  Rust プロジェクトのコーディングルールを提供します。
  所有権、イテレータ、パターンマッチングのベストプラクティスを含みます。
  Rust のコードを書く際に自動的にトリガーされます。
---

# Rust コーディングルール

## 基本パターン

- クローンより所有権を優先: 不必要な clone() を避ける
- イテレータを使用: ループより iter() チェーンを優先
- match 文を優先: if-else より match を使用

## 所有権の例

```rust
// 良い例: 参照を使用
fn process(data: &str) -> usize {
    data.len()
}

// 避けるべき: 不必要なクローン
fn process_bad(data: String) -> usize {
    data.len()
}
```

## イテレータの使用

```rust
// 良い例: イテレータチェーン
let sum: i32 = numbers
    .iter()
    .filter(|n| **n > 0)
    .map(|n| n * 2)
    .sum();

// 避けるべき: 手動ループ
let mut sum = 0;
for n in &numbers {
    if *n > 0 {
        sum += n * 2;
    }
}
```

## パターンマッチング

```rust
// 良い例: match で網羅的に処理
match result {
    Ok(value) => process(value),
    Err(Error::NotFound) => handle_not_found(),
    Err(Error::Permission) => handle_permission(),
    Err(e) => return Err(e),
}

// 避けるべき: unwrap() の多用
let value = result.unwrap(); // パニックの可能性
```
