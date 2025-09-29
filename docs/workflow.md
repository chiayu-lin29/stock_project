# 🚀 Workflow Guide

本文件說明團隊開發流程，包括如何 **pull / push / 開分支 / 發 PR**，以及基本命名規範。

---

## 1. 取得project

git clone https://github.com/<org>/<repo>.git
cd <repo>
git checkout dev

## 2. 開發流程
(a) 從 dev 切出 feature branch
git checkout dev
git pull origin dev
git checkout -b feature/<scope>-<desc>


👉 範例：feature/frontend-landing-page

(b) 開發並提交
git status
git add .
git commit -m "feat(frontend): add hero section on landing page"

(c) Push 到遠端
git push -u origin feature/<scope>-<desc>

(d) 開 Pull Request

目標分支 dev

使用 PR 模板填寫：Summary / Changes / Test / Checklist

至少 1 位 Reviewer 通過 + CI 綠燈

Squash & merge，然後刪除 branch

## 3. 合併回本地

PR 被合併後，本地更新：

git checkout dev
git pull origin dev

## 4. 常見問題
衝突解決
git fetch origin
git rebase origin/dev
# 解完衝突後
git add .
git rebase --continue
git push -f origin feature/<scope>-<desc>

禁止直接 push main

main 已啟用保護，必須透過 PR 合併。

## 5. 命名規範

分支：

feature/...（功能）

fix/...（修 bug）

hotfix/...（緊急修補）

Commit：feat: xxx、fix: xxx、docs: xxx

PR 標題：與 commit 一致，內容清楚

6. Workflow 流程圖
flowchart LR
  A[dev 分支] --> B[feature branch]
  B -->|push| C[GitHub]
  C --> D[開 Pull Request]
  D -->|Review & Merge| E[dev]
  E --> F[main]
