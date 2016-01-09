package com.github.demo.servlet;

import org.json.JSONArray;
import org.json.JSONObject;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;

@WebServlet(
        name = "ListenerServlet",
        urlPatterns = {"/event_handler"}
)
public class ListenerServlet extends HttpServlet {

    private static final String TOKEN = System.getenv("GHE_TOKEN");

    private String gheHost = null;

    private String targetUrl = null;

    @Override
    public void init(ServletConfig config) throws ServletException {
        super.init(config);

        if (TOKEN == null)
            throw new ServletException("Environment variable TOKEN missing");

        gheHost = System.getenv("GHE_HOST");
        if(gheHost == null || gheHost.isEmpty()) {
            gheHost = "https://octodemo.com/api/v3/";
        }

        targetUrl = System.getenv("TARGET_URL");
        if(targetUrl == null || targetUrl.isEmpty()) {
            targetUrl = "https://reading-time-app.herokuapp.com/";
        }
    }

    @Override
    public void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        doGet(req, resp);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        JSONObject obj = new JSONObject((String) request.getParameter("payload"));

        String event = request.getHeader("X-GitHub-Event");

        if (event.equalsIgnoreCase("issue_comment")) {

            String action = obj.getString("action");

            JSONObject issue = obj.getJSONObject("issue");

            String body = obj.getJSONObject("comment").getString("body");

            if (action.equalsIgnoreCase("created") && issue.has("pull_request") && shipIt(body)) {
                String url = issue.getJSONObject("pull_request").getString("url");
                startDeployment(url);
            }

        } else if (event.equalsIgnoreCase("deployment")) {
            processDeployment(obj);
        }

    }

    private void processDeployment(JSONObject obj) throws MalformedURLException, IOException, ServletException {
        String name = obj.getJSONObject("repository").getString("full_name");
        int deploymentId = obj.getJSONObject("deployment").getInt("id");

        JSONObject data = new JSONObject();
        data.put("state", "pending");
        data.put("target_url", targetUrl);
        data.put("description", "Pending deployment to heroku-test");

        URL url = new URL(gheHost + "repos/" + name + "/deployments/" + deploymentId + "/statuses");

        doCall(url, data);

        try {
            Thread.sleep(4000);
        } catch (InterruptedException e) {
            throw new ServletException("Execution interrupted");
        }

        data.put("state", "success");
        data.put("description", "Successful deployment to heroku-test");

        doCall(url, data);
    }

    private void startDeployment(String pullRequestUrl) throws MalformedURLException, IOException {
        System.err.println("Starting deployment...");

        JSONObject pullRequest = getPullRequest(pullRequestUrl);

        String name = pullRequest.getJSONObject("head").getJSONObject("repo").getString("full_name");
        String branchName = pullRequest.getJSONObject("head").getString("ref");

        JSONObject data = new JSONObject();
        data.put("ref", branchName);
        data.put("description", "Deploying to Heroku test");
        JSONArray array = new JSONArray();
        array.put("bogus-status-check/travis-ci");
        array.put("continuous-integration/travis-ci");
        data.put("required_contexts", array);
        data.put("environment", "heroku-test");

        URL url = new URL(gheHost + "repos/" + name + "/deployments");
        int reponseCode = doCall(url, data);
    }

    private int doCall(URL url, JSONObject data) throws MalformedURLException, IOException {
        HttpURLConnection connection = (HttpURLConnection) url.openConnection();
        connection.setRequestMethod("POST");
        connection.setRequestProperty("Authorization", "Token " + TOKEN);
        connection.setRequestProperty("Accept", "application/json");
        connection.setRequestProperty("Content-type", "application/json");
        connection.setDoOutput(true);
        OutputStreamWriter out = new OutputStreamWriter(
                connection.getOutputStream());
        out.write(data.toString());
        out.close();

        return connection.getResponseCode();
    }

    private JSONObject getPullRequest(String pullRequest) throws IOException {
        JSONObject obj = null;
        URL url = new URL(pullRequest);
        HttpURLConnection connection = (HttpURLConnection) url.openConnection();
        connection.setRequestProperty("Authorization", "Token " + TOKEN);
        connection.setRequestProperty("Accept", "application/json");
        connection.setRequestMethod("GET");
        connection.setDoInput(true);
        if (connection.getResponseCode() == 200) {
            BufferedReader bufferedReader = new BufferedReader(new InputStreamReader(connection.getInputStream()));
            StringBuilder stringBuilder = new StringBuilder();
            String line;
            while ((line = bufferedReader.readLine()) != null) {
                stringBuilder.append(line + '\n');
            }
            obj = new JSONObject(stringBuilder.toString());
        }
        return obj;
    }

    private boolean shipIt(String body) {
        if (body.contains(":ship:"))
            return true;
        if (body.contains(":shipit:"))
            return true;
        return false;
    }

}
