defmodule Utils.NotebooksTest do
  use ExUnit.Case, async: true
  alias Utils.Notebooks
  alias Utils.Notebooks.Notebook
  doctest Utils.Notebooks

  test "format_headings/1" do
    notebook = %Notebook{
      content: """
      # my awesome heading is great

      ## capitalize minors words like and the in to of
      ### but do capitalize other words
      #### and the first word no matter what
      """
    }

    assert %Notebook{
             content: """
             # My Awesome Heading Is Great

             ## Capitalize Minors Words Like And The In To Of
             ### But Do Capitalize Other Words
             #### And The First Word No Matter What
             """
           } = Notebooks.format_headings(notebook)
  end

  test "link_to_docs/1" do
    # [#{module}](https://hexdocs.pm/#{doc_link}/#{module}.html)
    # https://hexdocs.pm/#{doc_link}/#{module}.html##{function}/#{arity})
    # [
    #   {:kino, "0.9.0"},
    #   {:phoenix, "1.7.2"},
    #   {:benchee, "1.1.0"},
    #   {:poison, "5.0.0"},
    #   {:finch, "0.15.0"},
    #   {:timex, "3.7.11"},
    #   {:ecto, "3.9.5"}
    # ]

    notebook = %Notebook{
      content: """
      `ExUnit`
      `Kino`
      `Benchee`
      `IEx`
      `Mix`
      `Poison`
      `HTTPoison`
      `Finch`
      `Timex`
      `Ecto`
      `Phoenix`
      `ExUnit.run/1`
      `Phoenix.Flash.get_flash/2`
      `Phoenix.HTML.Form.checkbox/3`
      """
    }

    assert Notebooks.link_to_docs(notebook) == %Notebook{
             content: """
             [ExUnit](https://hexdocs.pm/ex_unit/ExUnit.html)
             [Kino](https://hexdocs.pm/kino/Kino.html)
             [Benchee](https://hexdocs.pm/benchee/Benchee.html)
             [IEx](https://hexdocs.pm/iex/IEx.html)
             [Mix](https://hexdocs.pm/mix/Mix.html)
             [Poison](https://hexdocs.pm/poison/Poison.html)
             [HTTPoison](https://hexdocs.pm/httpoison/HTTPoison.html)
             [Finch](https://hexdocs.pm/finch/Finch.html)
             [Timex](https://hexdocs.pm/timex/Timex.html)
             [Ecto](https://hexdocs.pm/ecto/Ecto.html)
             [Phoenix](https://hexdocs.pm/phoenix/Phoenix.html)
             [ExUnit.run/1](https://hexdocs.pm/ex_unit/ExUnit.html#run/1)
             [Phoenix.Flash.get_flash/2](https://hexdocs.pm/phoenix/Phoenix.Flash.html#get_flash/2)
             [Phoenix.HTML.Form.checkbox/3](https://hexdocs.pm/phoenix_html/Phoenix.HTML.Form.html#checkbox/3)
             """
           }
  end

  test "navigation_snippet/1 first notebook" do
    notebook = Notebooks.outline_notebooks() |> Enum.at(0)
    next = Notebooks.outline_notebooks() |> Enum.at(1)

    expected = """
    ## Navigation

    <div style="display: flex; align-items: center; width: 100%; justify-content: space-between; font-size: 1rem; color: #61758a; background-color: #f0f5f9; height: 4rem; padding: 0 1rem; border-radius: 1rem;">
    <div style="display: flex;">
    <i class="ri-home-fill"></i>
    <a style="display: flex; color: #61758a; margin-left: 1rem;" href="../start.livemd">Home</a>
    </div>
    <div style="display: flex;">
    <i class="ri-bug-fill"></i>
    <a style="display: flex; color: #61758a; margin-left: 1rem;" href="https://github.com/DockYard-Academy/curriculum/issues/new?assignees=&labels=&template=issue.md&title=#{notebook.title}">Report An Issue</a>
    </div>
    <div style="display: flex;">
    <i style="display: none;" class="ri-arrow-left-fill"></i>
    <a style="display: flex; color: #61758a; margin-left: 1rem;" href=""></a>
    </div>
    <div style="display: flex;">
    <a style="display: flex; color: #61758a; margin-right: 1rem;" href="#{next.relative_path}">#{next.title}</a>
    <i class="ri-arrow-right-fill"></i>
    </div>
    </div>
    """

    assert Notebooks.navigation_snippet(notebook) == expected
  end

  test "navigation_snippet/1 middle notebook" do
    prev = Notebooks.outline_notebooks() |> Enum.at(4)
    notebook = Notebooks.outline_notebooks() |> Enum.at(5)
    next = Notebooks.outline_notebooks() |> Enum.at(6)

    expected = """
    ## Navigation

    <div style="display: flex; align-items: center; width: 100%; justify-content: space-between; font-size: 1rem; color: #61758a; background-color: #f0f5f9; height: 4rem; padding: 0 1rem; border-radius: 1rem;">
    <div style="display: flex;">
    <i class="ri-home-fill"></i>
    <a style="display: flex; color: #61758a; margin-left: 1rem;" href="../start.livemd">Home</a>
    </div>
    <div style="display: flex;">
    <i class="ri-bug-fill"></i>
    <a style="display: flex; color: #61758a; margin-left: 1rem;" href="https://github.com/DockYard-Academy/curriculum/issues/new?assignees=&labels=&template=issue.md&title=#{notebook.title}">Report An Issue</a>
    </div>
    <div style="display: flex;">
    <i class="ri-arrow-left-fill"></i>
    <a style="display: flex; color: #61758a; margin-left: 1rem;" href="#{prev.relative_path}">#{prev.title}</a>
    </div>
    <div style="display: flex;">
    <a style="display: flex; color: #61758a; margin-right: 1rem;" href="#{next.relative_path}">#{next.title}</a>
    <i class="ri-arrow-right-fill"></i>
    </div>
    </div>
    """

    assert Notebooks.navigation_snippet(notebook) == expected
  end

  test "navigation_snippet/1 last notebook" do
    notebook = Notebooks.outline_notebooks() |> Enum.at(-1)
    prev = Notebooks.outline_notebooks() |> Enum.at(-2)

    expected = """
    ## Navigation

    <div style="display: flex; align-items: center; width: 100%; justify-content: space-between; font-size: 1rem; color: #61758a; background-color: #f0f5f9; height: 4rem; padding: 0 1rem; border-radius: 1rem;">
    <div style="display: flex;">
    <i class="ri-home-fill"></i>
    <a style="display: flex; color: #61758a; margin-left: 1rem;" href="../start.livemd">Home</a>
    </div>
    <div style="display: flex;">
    <i class="ri-bug-fill"></i>
    <a style="display: flex; color: #61758a; margin-left: 1rem;" href="https://github.com/DockYard-Academy/curriculum/issues/new?assignees=&labels=&template=issue.md&title=#{notebook.title}">Report An Issue</a>
    </div>
    <div style="display: flex;">
    <i class="ri-arrow-left-fill"></i>
    <a style="display: flex; color: #61758a; margin-left: 1rem;" href="#{prev.relative_path}">#{prev.title}</a>
    </div>
    <div style="display: flex;">
    <a style="display: flex; color: #61758a; margin-right: 1rem;" href=""></a>
    <i style="display: none;" class="ri-arrow-right-fill"></i>
    </div>
    </div>
    """

    assert Notebooks.navigation_snippet(notebook) == expected
  end

  test "commit_your_progress_snippet/1" do
    notebook = %Notebook{title: "My Notebook", type: :reading}

    assert Notebooks.commit_your_progress_snippet(notebook) == """
           ## Commit Your Progress

           DockYard Academy now recommends you use the latest [Release](https://github.com/DockYard-Academy/curriculum/releases) rather than forking or cloning our repository.

           Run `git status` to ensure there are no undesirable changes.
           Then run the following in your command line from the `curriculum` folder to commit your progress.
           ```
           $ git add .
           $ git commit -m "finish My Notebook reading"
           $ git push
           ```

           We're proud to offer our open-source curriculum free of charge for anyone to learn from at their own pace.

           We also offer a paid course where you can learn from an instructor alongside a cohort of your peers.
           [Apply to the DockYard Academy June-August 2023 Cohort Now](https://docs.google.com/forms/d/1RwqHc1wUoY0jS440sBJHHl3gyQlw2xhz2Dt1ZbRaXEc/edit?ts=641e1aachttps://academy.dockyard.com/).
           """
  end
end
