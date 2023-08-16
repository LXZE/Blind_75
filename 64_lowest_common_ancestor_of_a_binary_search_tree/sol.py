from typing import Optional

class TreeNode(object):
	def __init__(self, x):
		self.val = x
		self.left = None
		self.right = None
	def __repr__(self, tab = 0):
		return (
			f'''TreeNode({self.val}'''
			f'''{" " + str(self.left) if self.left is not None else ''}'''
			f'''{" " + str(self.right) if self.right is not None else ''})'''
		)

class Helper:
	@staticmethod
	def gentree(lst: list[int | None]) -> TreeNode:
		node_amount = len(lst)
		if not node_amount:
			return None
		def convert(index = 0) -> TreeNode:
			if index >= node_amount or lst[index] is None:
				return None
			node = TreeNode(lst[index])
			node.left = convert(2 * index + 1)
			node.right = convert(2 * index + 2)
			return node
		return convert()

	@staticmethod
	def detree(tree: TreeNode):
		res = []
		def traverse(node, res, offset = 0):
			if node is None:
				res.append((None, offset))
				return
			res.append((node.val, offset))
			traverse(node.left, res, 2*offset+1)
			traverse(node.right, res, 2*offset+2)
		traverse(tree, res)
		res.sort(key = lambda x: x[1], reverse = True)
		res = list(map(lambda x: x[0], res))
		while res[0] is None:
			res.pop(0)
		return res[::-1]

class Solution:
	def lowestCommonAncestor(self, root: 'TreeNode', p: 'TreeNode', q: 'TreeNode') -> 'TreeNode':
		if root.val > p.val and root.val > q.val: # all value less than current node
			return self.lowestCommonAncestor(root.left, p, q) # search on left branch
		elif root.val < p.val and root.val < q.val: # all value more than current node
			return self.lowestCommonAncestor(root.right, p, q) # search on right branch
		else:
			return root # otherwise, current node must be common node

null = None
tests: tuple[list[int | None]] = [
	({'root': [6,2,8,0,4,7,9,null,null,3,5], 'p': 2, 'q': 8}, 6),
	({'root': [6,2,8,0,4,7,9,null,null,3,5], 'p': 2, 'q': 4}, 2),
	({'root': [2,1], 'p': 2, 'q': 1}, 2),
]

sol = Solution()
for test, expect in tests:
	result = sol.lowestCommonAncestor(
		Helper.gentree(test['root']),
		Helper.gentree([test['p']]), Helper.gentree([test['q']])
	)
	assert result.val == expect
