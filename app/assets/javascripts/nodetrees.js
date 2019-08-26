$(function(){
  class NodeTree {
    constructor(nodeTree) {
      this.branches = nodeTree.branches;
    }

    static judgeAnswer(userNodes, sampleNodes) {
      // 同じ値でも違うオブジェクトだと == 比較ができないので文字列化して比較する
      const user = JSON.stringify(userNodes);
      const sample = JSON.stringify(sampleNodes);
      if (user == sample) {
        console.log('正解！');
      } else {
        console.log('のびしろですねぇ');
      }
    }

    getBranch(branchName) {
      const i = this.branches.findIndex(b => b.name == branchName);
      return this.branches[i];
    }

    getCommit(branchName, message) {
      const b = this.getBranch(branchName);
      const i = b.commits.findIndex(c => c.message == message);
      return b.commits[i];
    }

    addBranch(branchName) {
      this.branches.push({
        name: branchName,
        commits: [],
      });
    }

    addCommit(branchName, message) {
      const b = this.getBranch(branchName);
      b.commits.push({
        message: message,
      });
    }
  }

  // TODO ページ読み込み時にDBから取得してJSONで送ってくる
  const answer = {
    branches: [
      {
        name: 'b1',
        commits: [
          { message: 'add NodeTree model' },
          { message: 'add Branch model' },
          { message: 'add Commit model' },
        ],
      },
      {
        name: 'b2',
        commits: [
          { message: 'add ajax function' },
          { message: 'add NodeTree class' },
          { message: 'add methods for Nodetree' },
        ],
      },
    ]
  }

  // TODO ページ読み込み時にユーザー用のNodeTreeを作成してJSONで送ってくる
  const userSheet = {
    branches: [
      {
        name: 'b1',
        commits: [
          { message: 'add NodeTree model' },
          { message: 'add Branch model' },
          { message: 'add Commit model' },
        ],
      },
      {
        name: 'b2',
        commits: [
          // 解答よりコミットが1つ少ない状態
          { message: 'add ajax function' },
          { message: 'add NodeTree class' },
        ],
      },
    ]
  }

  const answerTree = new NodeTree(answer);
  // そのまま渡すと参照が渡されるので$.extendでコピーを作成する
  let userTree = new NodeTree($.extend(true, {}, userSheet));

  // 各メソッドの動作確認用
  // console.log(userTree)
  // console.log(userSheet)
  // console.log(userTree.getBranch('b1'))
  // console.log(userTree.getCommit('b1', 'add Branch model'))
  // userTree.addBranch('b3')
  // userTree.addCommit('b2','TEST')
  // console.log(userTree)
  // console.log(userSheet)

  // 正誤判定メソッドの動作確認用
  // 正解
  $('.js-correct').on('click',()=>{
    userTree.addCommit('b2', 'add methods for Nodetree')
    NodeTree.judgeAnswer(userTree, answerTree);
  })
  // 不正解
  $('.js-incorrect').on('click', ()=>{
    userTree.addCommit('b1', 'add methods for Nodetree')
    NodeTree.judgeAnswer(userTree, answerTree);
  })

  // 元に戻す
  $('.js-undo').on('click', ()=>{
    userTree = new NodeTree($.extend(true, {}, userSheet));
    console.log('解答をリセットしました');
  })
})
