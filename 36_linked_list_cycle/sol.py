from typing import Optional

# Definition for singly-linked list.
class ListNode:
    def __init__(self, x):
        self.val = x
        self.next = None

class Solution:
    def hasCycle(self, head: Optional[ListNode]) -> bool:
        visited = set()
        def loop(current: ListNode):
            if (current.val, current.next) in visited:
                return True
            if not current.next:
                return False
            visited.add((current.val, current.next))
            return loop(current.next)
        return loop(head) if head else False

tests = []
sol = Solution()
for (target, expect) in tests:
	assert sol.hammingWeight(target) == expect
