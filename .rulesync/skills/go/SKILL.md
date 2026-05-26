---
name: go
description: |
  Go プロジェクトのコーディングルールを提供します。
  エラーハンドリング、インターフェース設計、テストパターンを含みます。
  Go のコードを書く際に自動的にトリガーされます。
---

# Go コーディングルール

## 基本パターン

- 明示的なエラーハンドリング: エラーは必ず明示的に処理する
- インターフェースを優先: 具象型より抽象に依存
- テーブル駆動テストを使用: テストケースはテーブル形式で定義

## エラーハンドリングの例

```go
result, err := someOperation()
if err != nil {
    return fmt.Errorf("operation failed: %w", err)
}
```

## インターフェース設計

```go
type Reader interface {
    Read(p []byte) (n int, err error)
}

// 小さなインターフェースを定義し、必要に応じて組み合わせる
type ReadWriter interface {
    Reader
    Writer
}
```

## テーブル駆動テスト

```go
func TestAdd(t *testing.T) {
    tests := []struct {
        name     string
        a, b     int
        expected int
    }{
        {"positive", 1, 2, 3},
        {"negative", -1, -2, -3},
        {"zero", 0, 0, 0},
    }

    for _, tt := range tests {
        t.Run(tt.name, func(t *testing.T) {
            if got := Add(tt.a, tt.b); got != tt.expected {
                t.Errorf("Add(%d, %d) = %d; want %d", tt.a, tt.b, got, tt.expected)
            }
        })
    }
}
```
