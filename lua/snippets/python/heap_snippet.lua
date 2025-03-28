local ls = require("luasnip")
local new_snippet = ls.snippet
local i = ls.insert_node
local t = ls.text_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

local snippet = {
  python = {
    new_snippet(
      "heap",
      t([[
import heapq
heap = [1, 2, 65, 78, 98, 3, 6, 7, 99]  # it is not ordered
heapq.heapify(heap)  # this will mutate heap to be ordered
heapq.nlargest(3, heap)  # 3 max numbers
heapq.nsmallest(3, heap)  # 3 minor numbers
heapq.heappush(heap, -9)  # add a number on the heap (keeping it on the right order)
heapq.heappop(heap)  # remove the smallest number on the heap (keeping it on the right order)
heapq.heappushpop(heap, 12)  # add a new number and return the smallest one (keeping it on the right order)
heap[0]  # O(1) way to get the smallest number
heapq.nlargest(1, heap)  # get the greatest number (it will NOT necessarily be the last one on the array)
]])
    ),
  },
}

return snippet
