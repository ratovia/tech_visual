$(()=>{
  class NodeTree {
    constructor(nodeTree) {
      this.branches = nodeTree.branches;
    }

    static judgeAnswer(userNodes, sampleNodes) {
      const user = JSON.stringify(userNodes);
      const sample = JSON.stringify(sampleNodes);
      if (user == sample) {
        alert('正解！');
      } else {
        alert('のびしろですねぇ');
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

  const answer = {
    branches: [
      {
        name: 'b1',
        commits: [
          { message: 'add NodeTree model' },
          { message: 'add Branch model' },
          { message: 'add Commit model' },
        ]
      },
      {
        name: 'b2',
        commits: [
          { message: 'add ajax function' },
          { message: 'add NodeTree class' },
          { message: 'add methods for Nodetree' },
        ]
      }
    ]
  }

  // TODO ページ読み込み時にDBから取得してJSONで送ってくる
  const answer_tree = new NodeTree(answer);

  // TODO ページ読み込み時にユーザー用のNodeTreeを作成してJSONで送ってくる
  let user_tree = new NodeTree({
    branches: [
      {
        name: 'b1',
        commits: [
          { message: 'add NodeTree model' },
          { message: 'add Branch model' },
          { message: 'add Commit model' },
        ]
      },
      {
        name: 'b2',
        commits: [
          // 解答よりコミットが1つ少ない状態
          { message: 'add ajax function' },
          { message: 'add NodeTree class' },
        ]
      }
    ]
  });

  // 各メソッドの動作確認用
  // console.log(answer_tree.branches)
  // console.log(answer_tree.getBranch('b1'))
  // console.log(answer_tree.getCommit('b1', 'add Branch model'))
  // console.log(answer_tree.addBranch(3, 'b3'))
  // console.log(answer_tree.addCommit('b3','add NodeTree class'))
  // console.log(answer_tree.branches)

  // 正誤判定メソッドの動作確認用
  // 正解
  user_tree.addCommit('b2', 'add methods for Nodetree')
  // 不正解
  // user_tree.addCommits('b1', 'add methods for Nodetree')

  NodeTree.judgeAnswer(user_tree, answer_tree);
})
