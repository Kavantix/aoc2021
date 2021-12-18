import 'dart:collection';
import 'dart:convert';
import 'dart:math';

import '../common.dart';

abstract class Node {
  SubTree? parent;

  int get magnitude;

  Leaf? leafToTheLeft() {
    final parent = this.parent;
    if (parent == null) return null;
    if (parent.left == this) return parent.leafToTheLeft();
    var node = parent.left;
    while (true) {
      if (node is Leaf) return node;
      if ((node as SubTree).right is Leaf) return node.rightLeaf;
      node = node.right;
    }
  }

  Leaf? leafToTheRight() {
    final parent = this.parent;
    if (parent == null) return null;
    if (parent.right == this) return parent.leafToTheRight();
    if (parent.right is Leaf) return parent.rightLeaf;
    if (parent.rightTree.left is Leaf) return parent.rightTree.leftLeaf;
    var node = parent.right;
    while (true) {
      if (node is Leaf) return node;
      if ((node as SubTree).left is Leaf) return node.leftLeaf;
      node = node.left;
    }
  }

  int get numParents {
    int count = 0;
    var parent = this.parent;
    while (parent != null) {
      count += 1;
      parent = parent.parent;
    }
    return count;
  }
}

class SubTree extends Node {
  SubTree(this._left, this._right) {
    assert(_left.parent == null);
    assert(_right.parent == null);
    _left.parent = this;
    _right.parent = this;
  }

  SubTree clone() {
    return SubTree(
      left is Leaf ? Leaf(leftLeaf.value) : leftTree.clone(),
      right is Leaf ? Leaf(rightLeaf.value) : rightTree.clone(),
    );
  }

  @override
  int get magnitude => 3 * left.magnitude + 2 * right.magnitude;

  Node get left => _left;
  Node _left;
  set left(Node value) {
    _left.parent = null;
    _left = value;
    _left.parent = this;
  }

  Node get right => _right;
  Node _right;
  set right(Node value) {
    _right.parent = null;
    _right = value;
    _right.parent = this;
  }

  SubTree get leftTree => _left as SubTree;
  SubTree get rightTree => _right as SubTree;
  Leaf get leftLeaf => _left as Leaf;
  Leaf get rightLeaf => _right as Leaf;

  factory SubTree.fromList(List<Object?> list) {
    assert(list.length == 2);
    final leftPart = list[0];
    final Node left;
    if (leftPart is int) {
      left = Leaf(leftPart);
    } else {
      assert(leftPart is List<Object?>);
      left = SubTree.fromList(leftPart as List<Object?>);
    }
    final rightPart = list[1];
    final Node right;
    if (rightPart is int) {
      right = Leaf(rightPart);
    } else {
      assert(rightPart is List<Object?>);
      right = SubTree.fromList(rightPart as List<Object?>);
    }
    return SubTree(left, right);
  }

  factory SubTree.fromString(String input) {
    final json = jsonDecode(input) as List<Object?>;
    return SubTree.fromList(json);
  }

  void explode() {
    assert(_left is Leaf);
    assert(_right is Leaf);
    assert(parent != null);
    leafToTheLeft()?.value += leftLeaf.value;
    leafToTheRight()?.value += rightLeaf.value;
    if (parent!.left == this) {
      parent!.left = Leaf(0);
    } else if (parent!.right == this) {
      parent!.right = Leaf(0);
    } else {
      throw FallThroughError();
    }
  }

  int get depth {
    final left = _left;
    final right = _right;
    if (left is SubTree && right is SubTree) {
      return max(left.depth, right.depth) + 1;
    } else if (left is SubTree) {
      return left.depth + 1;
    } else if (right is SubTree) {
      return right.depth + 1;
    } else {
      return 1;
    }
  }

  void visitSubTrees(bool Function(SubTree subTree) visitor) {
    final subTrees = [this];
    while (subTrees.isNotEmpty) {
      final subTree = subTrees.removeLast();
      if (visitor(subTree)) {
        return;
      }
      if (subTree.right is SubTree) {
        subTrees.add(subTree.rightTree);
      }
      if (subTree.left is SubTree) {
        subTrees.add(subTree.leftTree);
      }
    }
  }

  void visitLeafs(bool Function(Leaf leaf) visitor) {
    final nodes = [
      right,
      left,
    ];
    while (nodes.isNotEmpty) {
      final node = nodes.removeLast();
      if (node is Leaf) {
        if (visitor(node)) {
          return;
        }
      }
      if (node is SubTree) {
        nodes.add(node.right);
        nodes.add(node.left);
      }
    }
  }

  void reduce() {
    bool didSplit;
    do {
      didSplit = false;
      while (depth > 4) {
        visitSubTrees((subTree) {
          if (subTree.numParents >= 4) {
            subTree.explode();
            return true;
          }
          return false;
        });
      }
      visitLeafs((leaf) {
        if (leaf.value >= 10) {
          leaf.split();
          didSplit = true;
          return true;
        }
        return false;
      });
    } while (depth > 4 || didSplit);
  }

  SubTree operator +(SubTree other) {
    final tree = SubTree(this, other);
    tree.reduce();
    return tree;
  }

  @override
  String toString() {
    return '[$left,$right]';
  }
}

class Leaf extends Node {
  Leaf(this.value);
  int value;

  @override
  int get magnitude => value;

  @override
  String toString() {
    return value.toString();
  }

  void split() {
    assert(value >= 10);
    final l = (value / 2).floor();
    final r = (value / 2).ceil();
    if (parent!.left == this) {
      parent!.left = SubTree(Leaf(l), Leaf(r));
    } else if (parent!.right == this) {
      parent!.right = SubTree(Leaf(l), Leaf(r));
    } else {
      throw FallThroughError();
    }
  }
}

final part1 = Part(
  parser: (lines) => lines.map(SubTree.fromString).toList(),
  implementation: (input) {
    final queue = Queue.of(input);
    var tree = queue.removeFirst();
    while (queue.isNotEmpty) {
      tree += queue.removeFirst();
    }
    print(tree);
    return tree.magnitude.toString();
  },
);

final part2 = Part(
  parser: (lines) => lines.map(SubTree.fromString).toList(),
  implementation: (input) {
    final pairs = <Tuple<SubTree, SubTree>>[];
    for (final number1 in input) {
      for (final number2 in input) {
        if (number1 == number2) continue;
        pairs.add(Tuple(number1, number2));
      }
    }
    int maxMagnitude = 0;
    for (final pair in pairs) {
      final sum = pair.value1.clone() + pair.value2.clone();
      maxMagnitude = max(maxMagnitude, sum.magnitude);
    }
    return maxMagnitude.toString();
  },
);
