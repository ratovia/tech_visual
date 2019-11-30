## ◆user モデル

### **●ユーザーテーブル**
ログインに必要なアカウント情報を入れておく。

| Column     | Type    | Options                  | memo                |
| :--------- | :------ | :----------------------- | :------------------ |
| name       | string  | null: false              |                     |
| email      | string  | null: false,unique: true |                     |
| password   | string  | null: false              |                     |
| role       | integer |                          | admin: 1, member: 2 |

### **●アソシエーション**
- has_many :shifts
- has_many :checkboxes
- has_many :attendances

## ◆Checkbox モデル

### **●チェックボックス管理テーブル**
シフト組に使用するチェックボックスの制約名、チェック有無を管理する

| Column     | Type       | Options                        | memo        |
| :--------- | :--------- | :----------------------------- | :---------- |
| user       | references | null: false, foreign_key: true |             |
| name       | string     | null: false                    |             |
| checked    | boolean    |                          　　　 |             |

### **●アソシエーション**
- belongs_to :user

## ◆WorkRole モデル

### **●作業役割管理テーブル**
作業名や仕事の役割名を管理する。

| Column     | Type   | Options     | memo        |
| :--------- | :----- | :---------- | :---------- |
| name       | string | null: false |             |

### **●アソシエーション**
- has_many :required_resources
- has_many :shifts

## ◆Shift モデル

### **●確定シフト管理テーブル**
誰が、どのwork_roleに、何時から何時まで入るのか管理する

| Column       | Type       | Options                        | memo          |
| :----------- | :--------- | :----------------------------- | :------------ |
| work_role    | references | null: false, foreign_key: true |               |
| user         | references | null: false, foreign_key: true |               |
| shift_in_at  | timestamps | null: false                    | シフトイン時間   |
| shift_out_at | timestamps | null: false                    | シフトアウト時間 |

### **●アソシエーション**
- belogns_to :workrole
- belogns_to :user

## ◆RequiredResource モデル

### **●必要リソース管理テーブル**
日ごと、work_roleごと、時間ごとに何人必要なのかを管理する

| Column    | Type       | Options                        | memo         |
| :-------- | :--------- | :----------------------------- | :----------- |
| what_day  | integer    | null: false, index: true       | enum　何曜日か |
| clock_at  | integer    | null: false, index: true       | 時刻          |
| count     | integer    | null: false                    | 人数   　　　  |
| work_role | references | null: false, foreign_key: true |              |

### **●アソシエーション**
- belongs_to :work_role

## ◆Attendance モデル

### **●勤怠管理テーブル**
各ユーザーの出勤日を管理する

| Column        | Type       | Options                        | memo    |
| :------------ | :--------- | :----------------------------- | :------ |
| date          | date       | null: false                    | 日付     |
| attendance_at | integer    | null: false                    | 出社時間  |
| leaving_at    | integer    | null: false                    | 退社時間  |
| user          | references | null: false, foreign_key: true |          |

### **●アソシエーション**
- belongs_to :user