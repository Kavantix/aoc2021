#! /usr/bin/env dart --enable-asserts

import 'dart:collection';

import 'day18.dart';

void main() {
  print('Parse subtree');
  {
    final subtree = SubTree.fromString('[[[[[9,8],1],2],3],4]');
    assert(subtree.left is SubTree);
    assert(subtree.right is Leaf);
    assert(subtree.left.parent == subtree);
    assert(subtree.right.parent == subtree);
    assert(subtree.leftTree.left is SubTree);
    assert(subtree.leftTree.right is Leaf);
    assert(subtree.leftTree.left.parent == subtree.left);
    assert(subtree.leftTree.right.parent == subtree.left);
    assert(subtree.depth == 5, subtree.depth);
    assert(SubTree.fromString('[1,2]').depth == 1);
  }
  print('✓');

  print('Visit leafs in order');
  {
    final tree = SubTree.fromString('[[3,[2,[1,[7,3]]]],[6,[5,[4,[3,2]]]]]');
    final leafs = <Leaf>[];
    tree.visitLeafs((leaf) {
      leafs.add(leaf);
      return false;
    });
    const expected = '3217365432';
    assert(leafs.join() == expected, leafs.join());
  }
  print('✓');

  print('Visit subtrees in order');
  {
    final tree = SubTree.fromString('[[3,[2,[1,[7,3]]]],[6,[5,[4,[3,2]]]]]');
    final subTreeOrder = Queue.of([
      tree,
      tree.leftTree,
      tree.leftTree.rightTree,
      tree.leftTree.rightTree.rightTree,
      tree.leftTree.rightTree.rightTree.rightTree,
      tree.rightTree,
      tree.rightTree.rightTree,
      tree.rightTree.rightTree.rightTree,
      tree.rightTree.rightTree.rightTree.rightTree,
    ]);
    final numSubTrees = subTreeOrder.length;
    tree.visitSubTrees((tree) {
      final expected = subTreeOrder.removeFirst();
      assert(tree == expected, '''


Expected: $expected
But got:  $tree
Trees left: ${subTreeOrder.length} of $numSubTrees
          ''');
      return false;
    });
  }
  print('✓');

  print('Leaf to the left');
  {
    var tree = SubTree.fromString('[[[[[9,8],1],2],3],4]');
    assert(tree.leftTree.leftTree.leftTree.leftTree.left is Leaf);
    var leafToTheLeft =
        tree.leftTree.leftTree.leftTree.leftTree.left.leafToTheLeft();
    assert(leafToTheLeft == null, leafToTheLeft.toString());
    tree = SubTree.fromString('[7,[6,[5,[4,[3,2]]]]]');
    assert(tree.rightTree.rightTree.rightTree.rightTree.left is Leaf);
    leafToTheLeft =
        tree.rightTree.rightTree.rightTree.rightTree.left.leafToTheLeft();
    assert(leafToTheLeft != null);
    assert(leafToTheLeft!.value == 4, leafToTheLeft.value);

    tree = SubTree.fromString('[[1, 2], [3, 4]]');
    Leaf? leaf3;
    tree.visitLeafs((leaf) {
      if (leaf.value == 3) {
        leaf3 = leaf;
        return true;
      }
      return false;
    });
    assert(leaf3 != null);
    assert(leaf3!.value == 3, leaf3!.value);
    assert(
      leaf3!.leafToTheLeft()?.value == 2,
      leaf3!.leafToTheLeft().toString(),
    );
  }
  print('✓');

  print('Leaf to the right');
  {
    var tree = SubTree.fromString('[[[[[9,8],1],2],3],4]');
    assert(tree.leftTree.leftTree.leftTree.leftTree.right is Leaf);
    var leafToTheRight =
        tree.leftTree.leftTree.leftTree.leftTree.right.leafToTheRight();
    assert(leafToTheRight != null, leafToTheRight.toString());
    assert(leafToTheRight!.value == 1, leafToTheRight.value);
    tree = SubTree.fromString('[7,[6,[5,[4,[3,2]]]]]');
    assert(tree.rightTree.rightTree.rightTree.rightTree.right is Leaf);
    leafToTheRight =
        tree.rightTree.rightTree.rightTree.rightTree.right.leafToTheRight();
    assert(leafToTheRight == null, leafToTheRight.toString());

    tree = SubTree.fromString('[[1, 2], [3, 4]]');
    Leaf? leaf2;
    tree.visitLeafs((leaf) {
      if (leaf.value == 2) {
        leaf2 = leaf;
        return true;
      }
      return false;
    });
    assert(leaf2 != null);
    assert(leaf2!.value == 2, leaf2!.value);
    assert(
      leaf2!.leafToTheRight()?.value == 3,
      leaf2!.leafToTheRight().toString(),
    );
  }
  print('✓');

  print('Explode example 1');
  {
    final tree = SubTree.fromString('[[[[[9,8],1],2],3],4]');
    assert(tree.leftTree.leftTree.leftTree.leftTree.left is Leaf);
    tree.leftTree.leftTree.leftTree.leftTree.explode();
    assert(
      tree.leftTree.leftTree.leftTree.left is Leaf,
      tree.leftTree.leftTree.leftTree.left.toString(),
    );
    assert(
      tree.leftTree.leftTree.leftTree.leftLeaf.value == 0,
      tree.leftTree.leftTree.leftTree.leftLeaf.toString(),
    );
    assert(
      tree.leftTree.leftTree.leftTree.right is Leaf,
      tree.leftTree.leftTree.leftTree.right.toString(),
    );
    assert(
      tree.leftTree.leftTree.leftTree.rightLeaf.value == 9,
      tree.leftTree.leftTree.leftTree.rightLeaf.toString(),
    );
  }
  print('✓');

  print('Explode example 2');
  {
    final tree = SubTree.fromString('[7,[6,[5,[4,[3,2]]]]]');
    assert(tree.rightTree.rightTree.rightTree.rightTree.right is Leaf);
    tree.rightTree.rightTree.rightTree.rightTree.explode();
    assert(
      tree.rightTree.rightTree.rightTree.right is Leaf,
      tree.rightTree.rightTree.rightTree.rightLeaf.toString(),
    );
    assert(
      tree.rightTree.rightTree.rightTree.rightLeaf.value == 0,
      tree.rightTree.rightTree.rightTree.rightLeaf.toString(),
    );
    assert(
      tree.rightTree.rightTree.rightTree.leftLeaf.value == 7,
      tree.rightTree.rightTree.rightTree.leftLeaf.toString(),
    );
  }
  print('✓');

  print('Explode example 3');
  {
    final tree = SubTree.fromString('[[3,[2,[1,[7,3]]]],[6,[5,[4,[3,2]]]]]');
    tree.reduce();
    const expected = '[[3,[2,[8,0]]],[9,[5,[7,0]]]]';
    assert(tree.toString() == expected, tree.toString());
  }
  print('✓');

  print('Addition example 0');
  {
    const input = '[[[[4,3],4],4],[7,[[8,4],9]]]\n[1,1]';
    final trees = input.split('\n').reversed.map(SubTree.fromString).toList();
    var tree = trees.removeLast();
    while (trees.isNotEmpty) {
      tree += trees.removeLast();
    }
    tree.reduce();
    const expected = '[[[[0,7],4],[[7,8],[6,0]]],[8,1]]';
    assert(tree.toString() == expected, tree.toString());
  }
  print('✓');

  print('Explode example 4');
  {
    const input = '''[1,1]
[2,2]
[3,3]
[4,4]
[5,5]
[6,6]''';
    final trees = input.split('\n').reversed.map(SubTree.fromString).toList();
    var tree = trees.removeLast();
    while (trees.isNotEmpty) {
      tree += trees.removeLast();
    }
    tree.reduce();
    const expected = '[[[[5,0],[7,4]],[5,5]],[6,6]]';
    assert(tree.toString() == expected, tree.toString());
  }
  print('✓');

  print('Explode example 5');
  {
    const input = '''[[[0,[4,5]],[0,0]],[[[4,5],[2,6]],[9,5]]]
[7,[[[3,7],[4,3]],[[6,3],[8,8]]]]''';
    final trees = input.split('\n').reversed.map(SubTree.fromString).toList();
    var tree = trees.removeLast()..reduce();
    while (trees.isNotEmpty) {
      tree += trees.removeLast()..reduce();
    }
    print(tree);
    tree.reduce();
    const expected =
        '[[[[4,0],[5,4]],[[7,7],[6,0]]],[[8,[7,7]],[[7,9],[5,0]]]]';
    assert(tree.toString() == expected, '''

Expected: $expected
But got:  $tree
        ''');
  }
  print('✓');

  print('Split example');
  {
    final tree = SubTree.fromString('[[[[0,7],4],[15,[0,13]]],[1,1]]');
    assert(tree.leftTree.rightTree.left is Leaf);
    tree.leftTree.rightTree.leftLeaf.split();
    assert(
      tree.leftTree.rightTree.left is SubTree,
      tree.leftTree.rightTree.left.toString(),
    );
    assert(
      tree.leftTree.rightTree.leftTree.left is Leaf,
      tree.leftTree.rightTree.leftTree.left.toString(),
    );
    assert(
      tree.leftTree.rightTree.leftTree.leftLeaf.value == 7,
      tree.leftTree.rightTree.leftTree.left.toString(),
    );
    assert(
      tree.leftTree.rightTree.leftTree.right is Leaf,
      tree.leftTree.rightTree.leftTree.right.toString(),
    );
    assert(
      tree.leftTree.rightTree.leftTree.rightLeaf.value == 8,
      tree.leftTree.rightTree.leftTree.right.toString(),
    );
  }
  print('✓');

  print('Addition example 1');
  {
    const input = '''[1,1]
[2,2]
[3,3]
[4,4]''';
    final trees = input.split('\n').reversed.map(SubTree.fromString).toList();
    assert(trees.length == 4);
    SubTree tree = trees.removeLast();
    tree += trees.removeLast();
    assert(
      tree.leftTree.leftLeaf.value == 1,
      tree.leftTree.leftLeaf.value,
    );
    while (trees.isNotEmpty) {
      tree += trees.removeLast();
    }
    assert(tree.right is SubTree);
    assert(tree.rightTree.right is Leaf);
    assert(
      tree.rightTree.rightLeaf.value == 4,
      tree.rightTree.rightLeaf.value,
    );
    assert(tree.leftTree.rightTree.right is Leaf);
    assert(
      tree.leftTree.rightTree.rightLeaf.value == 3,
      tree.leftTree.rightTree.rightLeaf.value,
    );
  }
  print('✓');

  print('Addition example 2');
  {
    const input = '''[[[0,[4,5]],[0,0]],[[[4,5],[2,6]],[9,5]]]
[7,[[[3,7],[4,3]],[[6,3],[8,8]]]]
[[2,[[0,8],[3,4]]],[[[6,7],1],[7,[1,6]]]]
[[[[2,4],7],[6,[0,5]]],[[[6,8],[2,8]],[[2,1],[4,5]]]]
[7,[5,[[3,8],[1,4]]]]
[[2,[2,2]],[8,[8,1]]]
[2,9]
[1,[[[9,3],9],[[9,0],[0,7]]]]
[[[5,[7,4]],7],1]
[[[[4,2],2],6],[8,7]]''';
    final trees = input.split('\n').reversed.map(SubTree.fromString).toList();
    assert(trees.length == 10);
    SubTree tree = trees.removeLast();
    while (trees.isNotEmpty) {
      tree += trees.removeLast();
    }
    const expected = '[[[[8,7],[7,7]],[[8,6],[7,7]]],[[[0,7],[6,6]],[8,7]]]';
    assert(tree.toString() == expected, tree.toString());
  }
  print('✓');
}
