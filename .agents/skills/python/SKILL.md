---
name: python
description: |
  Python プロジェクトのコーディングルールを提供します。
  型ヒント、docstring、dataclasses の使用パターンを含みます。
  Python のコードを書く際に自動的にトリガーされます。
---

# Python コーディングルール

## 基本パターン

- 型ヒント必須: すべての関数に型ヒントを付与
- 公開関数には docstring 必須: 公開 API には必ず docstring を記述
- dataclasses を使用: dict より dataclasses を優先

## 型ヒントの例

```python
def process_data(items: list[str], count: int = 10) -> dict[str, int]:
    """データを処理して結果を返す。

    Args:
        items: 処理対象の文字列リスト
        count: 処理する最大件数

    Returns:
        各アイテムの出現回数を格納した辞書
    """
    ...
```

## dataclasses の使用

```python
from dataclasses import dataclass

@dataclass
class User:
    name: str
    email: str
    age: int = 0
```
