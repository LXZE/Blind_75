class Node:
	def __init__(self, val = 0, neighbors = None):
		self.val = val
		self.neighbors = neighbors if neighbors is not None else []

class Solution:
	def cloneGraph(self, node: 'Node') -> 'Node':
		if not node: return None
		result = {}
		def clone(node: 'Node') -> 'Node':
			if node in result:
				return result[node]
			result[node] = copied_node = Node(node.val)
			copied_node.neighbors = list(map(clone, node.neighbors))
			return copied_node
		return clone(node)

tests: list[tuple[list, list]] = [
	([[2,4],[1,3],[2,4],[1,3]], [[2,4],[1,3],[2,4],[1,3]]),
	([[]], [[]]),
	([], []),
]
