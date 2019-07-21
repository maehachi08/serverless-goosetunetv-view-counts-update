# serverless-goosetunetv-view-counts-update

## Description

* AWS LambdaFunction資材
   * [goosetune.tv](http://goosetune.tv) 用のMySQL DB(AWS RDS)の動画再生回数を更新する
   * パッケージングとデプロイに[serverless framework](https://serverless.com/)

## Build

1. GoogleAPI のAPI KEY情報をセットする `.env` を作成する

   ```
   cp .env.sample .env
   vim .env
   ```

2. `app.rb` をAWS Lambda(ruby 2.5)で動作させる資材をビルドする

   ```
   docker run -v `pwd`:/var/task -it lambci/lambda:build-ruby2.5 bash build.sh
   ```

3. LambdaFunction をデプロイする

   ```
   sls deploy
   ```

