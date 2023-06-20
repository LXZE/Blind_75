from typing import Optional

# Definition for singly-linked list.
class ListNode:
    def __init__(self, x):
        self.val = x
        self.next = None

class Helper:
    def toLinkList(lst):
        if not lst:
            return None
        tmp = ListNode(lst[0])
        tmp.next = Helper.toLinkList(lst[1:])
        return tmp
    def toList(llist: ListNode):
        if not llist:
            return []
        res = [llist.val] + Helper.toList(llist.next)
        return res

class Solution:
    def size(self, head: Optional[ListNode], size = 0) -> int:
        if not head:
            return size
        return self.size(head.next, size+1)

    def split(self, node, target_idx, current_idx = 0) -> ListNode:
        if current_idx == target_idx:
            tmp = node.next
            node.next = None
            return tmp
        return self.split(node.next, target_idx, current_idx+1)

    def reverse(self, node, prev):
        if not node:
            return prev
        tmp = ListNode(node.val)
        tmp.next = prev
        return self.reverse(node.next, tmp)

    def start_reverse(self, node):
        if not node:
            return None
        return self.reverse(node.next, ListNode(node.val))

    def merge(self, l, r):
        if not r:
            l.next = r
            return
        tmp_l_next = l.next
        l.next = r
        self.merge(r, tmp_l_next)

    def reorderList(self, head: Optional[ListNode]) -> None:
        list_size = self.size(head)
        target_idx = (list_size//2)-1 if list_size % 2 == 0 else list_size//2
        right_side = self.start_reverse(self.split(head, target_idx))
        self.merge(head, right_side)

tests = [
    ([1,2,3,4], [1,4,2,3]),
    ([1,2,3,4,5], [1,5,2,4,3]),
    ([1], [1]),
]
sol = Solution()
for (target, expect) in tests:
    obj = Helper.toLinkList(target)
    sol.reorderList(obj)
    result_value = Helper.toList(obj)
    print(result_value, expect, result_value == expect)
    # assert result_value == expect
