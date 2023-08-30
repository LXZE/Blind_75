from typing import List

class Trie:
	def __init__(self):
		self.next = {}
		self.leaf = False
	
	def add_word(self, word: str):
		current = self
		for char in word:
			if char not in current.next:
				current.next[char] = Trie()
			current = current.next[char]
		current.leaf = True # mark current node as leaf after loop
	
	def prune_word(self, word: str):
		current = self
		node_n_child = []
		for char in word:
			node_n_child.append((current, char))
			current = current.next[char]
		
		for parent_node, child_key in node_n_child[::-1]: # try to remove from leaf
			target_node = parent_node.next[child_key]
			if len(target_node.next) == 0: # if current node is no child then remove
				del parent_node.next[child_key]
			else: # otherwise, just exit
				return

class Solution:
	def findWords(self, board: List[List[str]], words: List[str]) -> List[str]:
		root = Trie()
		for word in words:
			root.add_word(word)
		ROW_AMNT, COL_AMNT = len(board), len(board[0])
		result, visited = set(), set()

		def traverse(row: int, col: int, node: Trie, word: str):
			if (
				row < 0 or row >= ROW_AMNT or
				col < 0 or col >= COL_AMNT or
				(row, col) in visited or board[row][col] not in node.next
			):
				return
			visited.add((row, col))
			next_char = board[row][col]
			node = node.next[next_char] # move pointer to next node in trie by current character
			word += next_char
			if node.leaf:
				result.add(word)
				node.leaf = False
				root.prune_word(word)

			for (r, c) in [(row-1, col), (row+1, col), (row, col-1), (row, col+1)]:
				traverse(r, c, node, word)
			
			visited.remove((row, col))

		for r in range(ROW_AMNT):
			for c in range(COL_AMNT):
				traverse(r,c,root,'')
		
		return list(result)


tests = [
	(
		{
			'board': [["o","a","a","n"],["e","t","a","e"],["i","h","k","r"],["i","f","l","v"]],
			'words': ["oath","pea","eat","rain"]
		},
		["eat","oath"]
	),
]

sol = Solution()
for (test, expect) in tests:
	result = sol.findWords(test['board'], test['words'])
	print(result, expect, result == expect)
	# assert result_value == expect