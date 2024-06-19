local lyaml = require 'lyaml'
local file = io.open('src/resume.yaml', 'r')
local content = file:read "*a"
file:close()

local resume = lyaml.load(content)

function resume.print_education(print)
    for _, v in pairs(resume.education) do
        print(
                { "\\activitytitle{" },
                { -2, v.school },
                { "}{" },
                { -2, v.location },
                { "}\\\\", "\\subactivity{" },
                { -2, v.degree },
                { "}{" },
                { -2, v.graduation },
                { "}", "\\begin{itemize}" }
        )
        for _, desc in pairs(v.description) do
            print({ "\\item " }, { -2, desc })
        end
        print { "\\end{itemize}", "\\linespace" }
    end
end

function resume.print_skills(print)
    print { "\\begin{itemize}" }
    for _, v in pairs(resume.skills) do
        print(
                { "\\item ", "\\textbf{" },
                { -2, v.category },
                { ":} " },
                { -2, table.concat(v.skills, ", ") }
        )
    end
    print { "\\end{itemize}", "\\linespace" }
end

function resume.print_experience(print)
    for _, v in pairs(resume.experience) do
        print(
                { "\\activitytitle{" },
                { -2, v.company },
                { "}{" },
                {-2, v.location },
                { "}\\\\" }
        )
        for _, job in pairs(v.positions) do
            combined_dates = {}
            for i, dates in pairs(job.dates) do
                combined_dates[i] = dates.start .. " – " .. dates["end"]
            end
            print(
                    { "\\subactivity{" },
                    { -2, job.title },
                    { "}{" },
                    {-2, table.concat(combined_dates, ", ") },
                    { "}", "\\begin{itemize}" }
            )
            for _, desc in pairs(job.description) do
                print({ "\\item " }, { -2, desc })
            end
            print { "\\end{itemize}", "\\linespace" }
        end
    end
end

function resume.print_projects(print)
    for _, v in pairs(resume.projects) do
        print(
                { "\\activitytitle{" },
                { -2, v.title },
                { " {\\normalfont(" },
                { -2, table.concat(v.technologies, ", ") },
                { ")}}{\\normalfont\\textit{" },
                { -2, v.date },
                { "}}", "\\begin{itemize}" }
        )
        for _, desc in pairs(v.description) do
            print({ "\\item " }, { -2, desc })
        end
        print { "\\end{itemize}", "\\linespace" }
    end
end


return resume
