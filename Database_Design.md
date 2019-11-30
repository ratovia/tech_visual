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

## ◆Checkbox モデル

### **●チェックボックス管理テーブル**
シフト組に使用するチェックボックスの制約名、チェック有無を管理する

| Column     | Type    | Options                        | memo        |
| :--------- | :------ | :----------------------------- | :---------- |
| user_id    | bigint  | null: false, foreign_key: true |             |
| name       | string  | null: false                    |             |
| checked    | boolean |                          　　　 |             |

### **●アソシエーション**
- belongs_to :user

## ◆WorkRole モデル

### **●作業役割管理テーブル**
作業名や仕事の役割名を管理する。

| Column     | Type   | Options                  | memo        |
| :--------- | :----- | :----------------------- | :---------- |
| name       | string | null: false              |             |

### **●アソシエーション**
- has_many :shifts
- has_one :sum, class_name: 'Resource', foreign_key: 'workrole_id'
- has_one :required, class_name: 'Resource', foreign_key: 'workrole_id'

## ◆Shift モデル
### **●シフトテーブル**
シフトの情報を格納する。どの場所に何時から何時まで誰がシフトインするか管理する。

| Column       | Type          | Options                        | memo          |
| :----------- | :-----------  | :----------------------------- | :------------ |
| workrole_id  | bigint        | null: false, foreign_key: true |               |      
| user_id      | bigint        | null: false, foreign_key: true |               |
| shift_in_at  | timestamps    | null: false                    | シフトイン時間   |
| shift_out_at | timestamps    | null: false                    | シフトアウト時間 |

### **●アソシエーション**
- belogns_to :workrole
- belogns_to :user

## ◆Assign モデル
### **●リソーステーブル**

該当時間に対する人数割り当て情報を格納する。

| Column               | Type    | Options                        | memo          |
| :------------------- | :------ | :----------------------------- | :------------ |
| clock_at             | integer | null: false                    | 時刻           |
| count                | integer | null: false                    | 人数   　　　   |


### **●アソシエーション**
- belongs_to: resources

## Resource モデル
### **●リソーステーブル**
作業や役割毎にどのくらい合計リソース・必要リソースがあるか管理する

| Column      | Type   | Options                        | memo |
| :---------- | :----- | :----------------------------- | :--- |
| workrole_id | bigint | null: false, foreign_key: true |      |      
  

### **●アソシエーション**
- belogns_to :sum_workrole, class_name: 'WorkRole', foreign_key: 'workrole_id'
- belogns_to :required_workrole, class_name: 'WorkRole', foreign_key: 'workrole_id'
- has_many :assign