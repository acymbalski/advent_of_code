nums = []
sm = 0
sm_alt = 0

with open("input1.txt", 'r') as f:
	for c in f.readlines():
		nums = list(c)
		nums.remove("\n")

print("len(nums) = {}".format(len(nums)))

for n in range(len(nums) - 1):
	if nums[n] == nums[n + 1]:
		sm += int(nums[n])
if nums[len(nums) - 1] == nums[0]:
	sm += int(nums[0])

for n in range(len(nums) - 1):
	m = int(n + len(nums) / 2)
	if m >= len(nums):
		m -= len(nums)
	if nums[n] == nums[m]:
		sm_alt += int(nums[n])


print("sum (std): " + str(sm))
print("sum (alt): " + str(sm_alt))
