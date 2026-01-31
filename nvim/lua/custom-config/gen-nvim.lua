--[[ /// <summary>
    /// [summary_here]
    /// </summary> ]]
local gen = require "gen"

gen.prompts['Summarize_Function'] = {
  prompt = "Write a very short summary (maximum 1 phrase, keep them short as well) for the following method, start the phrase with '/// ':\n$text",
  replace = false
}

return {}
