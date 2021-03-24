# Reading Time

このReading Timeアプリは、スタッフのオススメの書籍を紹介するWebアプリケーションです。

## インストール

### 準備

このアプリでは Java と[Maven](https://maven.apache.org/)が必要です。また、組込み Tomcat サーブレットコンテナを使用しています。Java と Maven がインストールされているかどうかを確認するには、ターミナルで以下のコマンドを実行して下さい：

```
mvn --version
```

aaa

### 起動

アプリケーションを起動するには以下のコマンドを実行して下さい：

```
mvn clean install
sh target/bin/webapp
open http://localhost:8080
```

テストを実行しないでインストールするには以下のコマンドを実行して下さい：

```
mvn -B -DskipTests=true clean install
```

ユニットテストを実行するには以下のコマンドを実行して下さい：

```
mvn clean test
```

## Actions の設定

このプロジェクトでは 2 つのワークフローを実行します。

1. フィーチャーブランチへの push のたびにビルド（コンパイル、ユニットテスト）の実行
2. master へのマージのたびにビルド・Azure Web App へのデプロイ

### デプロイする Azure Web App の設定

デプロイする先の Azure Web App の指定は、`pom.xml`の azure-webapp-maven-plugin の配下に以下の記述を追記して下さい。

```xml
                    <subscriptionId>7c458c93-920c-4ed1-b26d-5b4ab57c0711</subscriptionId>
                    <resourceGroup>reading-times</resourceGroup>
                    <appName>reading-time-app</appName>
```

お使いの Azure Web App の `subscriptionId` を確認するには、以下のコマンドを実行して下さい：

```shell
$ az account list
```

### 認証情報

Azure へのデプロイの際の認証をするためには、 [パスワードベースのサービスプリンシパルを作成する](https://docs.microsoft.com/ja-jp/cli/azure/create-an-azure-service-principal-azure-cli?view=azure-cli-latest#password-based-authentication)必要があります。

そして、リポジトリの設定画面から以下の Secret を設定して下さい。

| Secrets      |                                  |
| ------------ | -------------------------------- |
| AZ_USER_NAME | サービスプリンシパルのユーザー名 |
| AZ_PASSWORD  | サービスプリンシパルのパスワード |
| AZ_TENANT_ID | サービスプリンシパルの Tenant ID |

## このプロジェクトに貢献する方法

[CONTRIBUTING](.github/CONTRIBUTING.md) ファイルにこのプロジェクトに貢献する方法を記載しています。

## ライセンス

このプロジェクトはMITライセンスの元配布されています。詳細については[LICENSE](LICENSE.md)ファイルを御覧ください。

