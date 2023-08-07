from typing import Optional

class TreeNode(object):
	def __init__(self, x):
		self.val = x
		self.left = None
		self.right = None
	def __repr__(self, tab = 0):
		return f'''TreeNode({self.val} {self.left} {self.right})'''

class Helper:
	@staticmethod
	def gentree(lst: list[int | None]) -> TreeNode:
		def traverse(order):
			val = next(order, None)
			print(val)
			if val is None: return None
			node = TreeNode(val)
			node.left = traverse(order)
			node.right = traverse(order)
			return node
		return traverse(iter(lst))

	@staticmethod
	def detree(root: TreeNode):
		def preorder(node):
			if node is None:
				yield None
			else:
				yield node.val
				yield from preorder(node.left)
				yield from preorder(node.right)
		# it = iter(preorder(root))
		# while True:
		# 	val = next(it)
		# 	print(val)
		res = list(preorder(root))
		while res and res[-1] is None:
			res.pop()
		return res

	@staticmethod
	def try_map_int(s: str) -> int | None:
		if s == 'None':
			return None
		return int(s)


class Codec:
	def serialize(self, root: TreeNode) -> str:
		"""Encodes a tree to a single string.

		:type root: TreeNode
		:rtype: str
		"""
		lst = Helper.detree(root)
		return str(lst)[1:-1]

	def deserialize(self, data: str) -> TreeNode:
		"""Decodes your encoded data to tree.

		:type data: str
		:rtype: TreeNode
		"""
		if data == '':
			return None
		lst = list(map(Helper.try_map_int, data.split(', ')))
		return Helper.gentree(lst)

null = None
tests: list[list[int | None]] = [
	# [1,2,3,null,null,4,5],
	# [],
	# [1],
	[1,2,3,null,null,4,5,6,7],
	# [4,-7,-3,null,null,-9,-3,9,-7,-4,null,6,null,-6,-6,null,null,0,6,5,null,9,null,null,-1,-4,null,null,null,-2],
]

sol = Codec()
for test in tests:
	result_ser = sol.serialize(Helper.gentree(test))
	# list_result = Helper.detree(sol.deserialize(result_ser))
	# assert test == list_result
