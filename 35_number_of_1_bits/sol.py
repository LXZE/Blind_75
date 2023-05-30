class Helper:
	@staticmethod
	def convert(n: str):
		return int(f'0b{n}', 2)


class Solution:
	def hammingWeight(self, n: int) -> int:
		res = 0
		while n > 0:
			res += n & 1
			n >>= 1
		return res

tests: list[tuple[list, list]] = [
	('00000000000000000000000000001011', 3),
	('00000000000000000000000010000000', 1),
	('11111111111111111111111111111101', 31),
]

sol = Solution()
for (target, expect) in tests:
	assert sol.hammingWeight(Helper.convert(target)) == expect