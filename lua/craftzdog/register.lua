local function clear_registers()
  print("Hàm clear_registers đã được gọi")
  for i = 97, 122 do
    vim.fn.setreg(string.char(i), "")
  end
  for i = 48, 57 do
    vim.fn.setreg(tostring(i), "")
  end
end
vim.api.nvim_set_keymap("n", "<Leader><Delete>", "", { noremap = true, silent = true, callback = clear_registers })
