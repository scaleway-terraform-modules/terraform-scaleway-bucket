# Contributing Guidelines

Thank you for your interest in contributing to our project. Whether it's a bug report, new feature, correction, or additional
documentation, we greatly value feedback and contributions from our community.

Please read through this document before submitting any issues or pull requests to ensure we have all the necessary
information to effectively respond to your bug report or contribution.


## Reporting Bugs/Feature Requests

We welcome you to use the GitHub issue tracker to report bugs or suggest features.

When filing an issue, please check existing open, or recently closed, issues to make sure somebody else hasn't already
reported the issue. Please try to include as much information as you can. Details like these are incredibly useful:

* A reproducible test case or series of steps
* The version of our code being used
* Any modifications you've made relevant to the bug
* Anything unusual about your environment or deployment


## Contributing via Pull Requests
Contributions via pull requests are much appreciated. Before sending us a pull request, please ensure that:

1. You are working against the latest source on the *main* branch.
2. You check existing open, and recently merged, pull requests to make sure someone else hasn't addressed the problem already.
3. You open an issue to discuss any significant work - we would hate for your time to be wasted.

To send us a pull request, please:

1. Fork the repository.
2. Modify the source; please focus on the specific change you are contributing. If you also reformat all the code, it will be hard for us to focus on your change.
3. Ensure local tests pass.
4. Commit to your fork using clear commit messages.
5. Send us a pull request, answering any default questions in the pull request interface.
6. Pay attention to any automated CI failures reported in the pull request, and stay involved in the conversation.

GitHub provides additional document on [forking a repository](https://help.github.com/articles/fork-a-repo/) and
[creating a pull request](https://help.github.com/articles/creating-a-pull-request/).


## AI-assisted contributions
Contributions made with the help of AI tools (Claude, ChatGPT, Copilot, Gemini, Mistral, local models, ...) are welcome, as long as they are explicit.

* **You are responsible for what you submit.** Contributions made with AI sit under the responsibility of their operator, the person running the tool. You must have reviewed, understood and tested every change, be able to answer review comments yourself, and make sure the code can be published under the project's license.
* **Disclose AI usage in each commit.** Every commit containing work produced or modified by an AI must end with a `Co-Authored-By:` trailer per AI involved, giving the model, its version and any relevant detail (tool, model identifier, reasoning effort, local or hosted, ...):

  ```text
  Co-Authored-By: <model name> <model version> (<details>) <email>
  ```

  For example: `Co-Authored-By: Claude Opus 5.5 (claude-opus-5-5; Claude Code; effort: high) <noreply@anthropic.com>`.
* **Disclose AI usage in the pull request** by filling in the "AI usage" section of the pull request template.
* Maintainers squashing a pull request must keep the `Co-Authored-By:` trailers in the final commit message.

Repositories may also contain an `AGENTS.md` file with instructions for AI agents themselves.


## Finding contributions to work on
Looking at the existing issues is a great way to find something to contribute on. As our projects, by default, use the default GitHub issue labels (enhancement/bug/duplicate/help wanted/invalid/question/wontfix), looking at any 'help wanted' issues is a great place to start.


## Licensing

See the LICENSE file for our project's licensing.
