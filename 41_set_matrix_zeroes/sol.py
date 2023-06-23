from typing import List

class Solution:
    def setZeroes(self, matrix: List[List[int]]) -> None:
        ROW_AMNT, COL_AMNT = len(matrix), len(matrix[0])
        target_col = set()
        target_row = set()
        for idx_row, row in enumerate(matrix):
            for idx_col, elem in enumerate(row):
                elem
                if idx_col in target_col:
                    pass
                if elem == 0:
                    target_col.add(idx_col)
                    target_row.add(idx_row)
        for row in target_row:
            for col in range(COL_AMNT):
                matrix[row][col] = 0
        for col in target_col:
            for row in range(ROW_AMNT):
                matrix[row][col] = 0

tests = [
    (
         [[1,1,1],[1,0,1],[1,1,1]],
         [[1,0,1],[0,0,0],[1,0,1]]
    ),
    (
        [[0,1,2,0],[3,4,5,2],[1,3,1,5]],
        [[0,0,0,0],[0,4,5,0],[0,3,1,0]]
    )
]

sol = Solution()
for (target, expect) in tests:
    sol.setZeroes(target)
    print(target, expect, target == expect)
    # assert result_value == expect
