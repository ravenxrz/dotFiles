-- 检测 Python 文件的缩进并设置相应缩进
local function detect_python_indent()
  for line in io.lines(vim.fn.expand("%")) do
    local spaces = line:match("^(%s*)") -- 匹配每行开头的空格
    if spaces then
      local tabsize = #spaces         -- 计算空格数
      if tabsize > 0 then
        vim.opt_local.expandtab = true
        vim.opt_local.shiftwidth = tabsize
        vim.opt_local.softtabstop = tabsize
        vim.opt_local.tabstop = tabsize
        break -- 设置完毕后退出循环
      end
    end
  end
end

-- 设置自动命令
vim.api.nvim_create_augroup("DetectPythonIndent", { clear = true })
vim.api.nvim_create_autocmd("BufReadPost", {
  pattern = "*.py",
  callback = function() -- some others plugins set indent too, delay some time to let them go first
    vim.defer_fn(detect_python_indent, 10)
  end,
  group = "DetectPythonIndent",
})