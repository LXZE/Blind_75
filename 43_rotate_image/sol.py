from typing import List
import math

class Solution:
    def rotate(self, matrix: List[List[int]]) -> None:
        """
        Do not return anything, modify matrix in-place instead.
        """
        lim = len(matrix) - 1
        mid = math.ceil(len(matrix)/2) - 1
        for row in range(mid + (lim % 2)):
            for col in range(mid+1):
                [
                    matrix[row][col],
                    matrix[col][lim-row],
                    matrix[lim-row][lim-col],
                    matrix[lim-col][row]
                ] = [
                    matrix[lim-col][row],
                    matrix[row][col],
                    matrix[col][lim-row],
                    matrix[lim-row][lim-col]
                ]

tests = [
    (
         [[1,2,3],[4,5,6],[7,8,9]],
         [[7,4,1],[8,5,2],[9,6,3]]
    ),
    (
        [[5,1,9,11],[2,4,8,10],[13,3,6,7],[15,14,12,16]],
        [[15,13,2,5],[14,3,4,1],[12,6,8,9],[16,7,10,11]]
    )
]

sol = Solution()
for (target, expect) in tests:
    sol.rotate(target)
    print(target, expect, target == expect)
    # assert result_value == expect
